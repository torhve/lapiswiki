http = require "lapis.nginx.http"
db = require "lapis.nginx.postgres"
lapis = require "lapis.init"
csrf = require "lapis.csrf"
console = require "lapis.console"
html = require "lapis.html"
io = require "io"
os = require "os"

import respond_to, capture_errors, assert_error, yield_error from require "lapis.application"
import validate, assert_valid from require "lapis.validate"
import escape_pattern, trim_filter from require "lapis.util"

import WikiPages, Revisions from require "models"

secure_filename = (filename) ->
    filename = string.gsub(filename, '/', '')
    filename = string.gsub(filename, '%.%.', '')
    -- Filenames with spaces are just a hassle
    filename = string.gsub(filename, ' ', '_')
    filename

slugify = (str) ->
    (str\gsub("%s+", "-")\gsub("[^%w%-_]+", ""))

class extends lapis.Application
    layout: require "views.layout"

    [index: "/"]: =>
        @page_description = "Welcome To LapisWiki"
        @page_title = "Welcome to LapisWiki"
        render: true

    [all: "/all/"]: =>
        @page_title = "All wiki pages"
        @pages = WikiPages\select "order by slug asc"
        render: true

    [wikipage: "/wiki/:slug"]: respond_to {
      GET: =>
        @page = assert WikiPages\find(slug: @params.slug), 'No page found'
        @page_description = @page.slug
        @page_title = @page.slug

        if @params['revision']
            @revisions = assert_error Revisions\select "where wiki_page_id = ? and id = ?", @page.id, @params['revision']
        else
            @revisions = assert_error Revisions\select "where wiki_page_id = ? order by updated_at desc", @page.id

        render: true

      POST: capture_errors =>
        @page = assert_error WikiPages\find(slug: @params.slug)
        assert_valid @params, {
            { 'content', exists: true, min_length: 1 }
        }
        {:content } = @params
        ip = ngx.var.remote_addr
        revision = assert_error Revisions\create @page, content, ip
    }
    [revisions: "/wiki/:slug/revisions/"]:  =>
        @page = assert WikiPages\find(slug: @params.slug), 'No page found'
        @page_description = @page.slug
        @page_title = @page.slug

        @revisions = assert_error Revisions\select "where wiki_page_id = ? order by updated_at desc", @page.id

        render: true

    [new: "/new"]: respond_to {
      before: =>
        @page_title = "Create document"
        @page_description = "Create new document"

      GET: =>
        @csrf_token = csrf.generate_token @
        render: true

      POST: capture_errors =>
        csrf.assert_token @
        assert_valid @params, {
            { 'slug', exists: true, min_length: 3, max_length: 75 }
        }
        {:slug } = @params
        slug = slugify slug
        page = assert_error WikiPages\create slug
        redirect_to: @url_for("wikipage", slug: slug)
    }

    [search: "/search"]: capture_errors =>
        {:q} = @params
        @page_title = 'Search for ' .. q
        @query = q
        res = db.query "SELECT * FROM wiki_pages WHERE to_tsvector(slug) @@ to_tsquery(?)", q .. ':*'
        --  select distinct on (wiki_page_id) r.* wiki_page_id from revisions r, wiki_pages w where r.wiki_page_id = w.id order by wiki_page_id, r.updated_at desc
        @titlematches = res['resultset']
        if #@titlematches == 1
            redirect_to: @url_for("wikipage", slug:@titlematches[1].slug)
        else
            render: true

    [upload: "/upload/"]: respond_to {
      GET: =>
        render: false

      POST: =>
        csrf.assert_token @
        assert_valid @params, {
            {'upload', file_exists: true}
        }
        file = @params.upload
        content = file.content
        timestamp = ngx.now!
        filename = secure_filename file.filename
        fileurl = 'static/uploads/'..timestamp..'_'..filename
        diskfile = io.open fileurl, 'w'
        diskfile\write file.content
        diskfile\close

        {:type, :CKEditorFuncNum } = @params
        message = '' -- XXX add lots of error checking
        url = '/' .. fileurl

        res = "<script type='text/javascript'>window.parent.CKEDITOR.tools.callFunction(#{CKEditorFuncNum}, '#{url}', '#{message}');</script>"
        @write res
    }

    --"/db/make": =>
    --    schema = require "schema"
    --    schema.make_schema!
    --    json: { status: "ok" }

    --"/db/nuke": =>
    --    schema = require "schema"
    --    schema.destroy_schema!
    --    json: { status: "ok" }

    "/console": console.make!


