http = require "lapis.nginx.http"
db = require "lapis.nginx.postgres"
lapis = require "lapis.init"
csrf = require "lapis.csrf"
console = require "lapis.console"
html = require "lapis.html"
io = require "io"

import respond_to, capture_errors, assert_error, yield_error from require "lapis.application"
import validate, assert_valid from require "lapis.validate"
import escape_pattern, trim_filter from require "lapis.util"
import split from require "moonscript.util"

import WikiPages, Revisions, Tags, TagsPageRelation from require "models"

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
        redirect_to: @url_for("wikipage", slug: 'home')

    [all: "/all/"]: =>
        @title = "All wiki pages"
        @pages = WikiPages\select "order by slug asc"
        render: true

    [alltags: "/tag/"]: =>
        @title = "All tags"
        @tags = Tags\select "order by name asc"
        render: true

    [tag: "/tag/:name"]: =>
        @tag = @params.name
        @title = "All pages for tag"
        @pages = WikiPages\select [[
            INNER JOIN tags_page_relation r 
                ON (r.wiki_page_id = wiki_pages.id)
            INNER JOIN tags t
                ON (t.id = r.tags_id)
        WHERE name = ? order by slug ASC]], @tag
        render: true

    [recent: "/recent/"]: =>
        @title = "Recent changes"
        res = db.query 'select * from (select distinct on (r.wiki_page_id) r.*, w.id, w.slug from revisions r, wiki_pages w where r.wiki_page_id = w.id order by r.wiki_page_id, updated_at) as pages order by updated_at desc'
        @pages = res['resultset']
        render: true

    [wikipage: "/wiki/:slug"]: respond_to {
      GET: =>
        @page = assert WikiPages\find(slug: @params.slug), 'No page found'
        @page_description = @page.slug
        @title = @page.slug

        if @params['revision']
            @revisions = assert_error Revisions\select "where wiki_page_id = ? and id = ?", @page.id, @params['revision']
        else
            @revisions = assert_error Revisions\select "where wiki_page_id = ? order by updated_at desc", @page.id

        @tags = assert_error Tags\select [[
            INNER JOIN tags_page_relation r
                ON (tags.id = r.tags_id)
            WHERE wiki_page_id = ?
            ]], @page.id

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
        @title = @page.slug

        @revisions = assert_error Revisions\select "where wiki_page_id = ? order by updated_at desc", @page.id

        render: true

    [tags: "/wiki/:slug/tags/"]: respond_to {
        before: =>
            @page = assert WikiPages\find(slug: @params.slug), 'No page found'
            @page_description = @page.slug
            @title = @page.slug
        GET: =>

            @tags = assert_error Tags\select [[
                INNER JOIN tags_page_relation r
                    ON (tags.id = r.tags_id)
                WHERE wiki_page_id = ?
                ]], @page.id

            render: true
        POST: =>
            name = @params.name
            --- XXX better postgresql unique check ?
            --- 
            @tag = Tags\find name: name
            unless @tag
                @tag = Tags\create name
            @relation = TagsPageRelation\create @page.id, @tag.id
            -- XXX DRY how ??
            @tags = assert_error Tags\select [[
                INNER JOIN tags_page_relation r
                    ON (tags.id = r.tags_id)
                WHERE wiki_page_id = ?
                ]], @page.id

            render: true
        }

    [new: "/new"]: respond_to {
      before: =>
        @title = "Create document"
        @page_description = "Create new document"

      GET: =>
        @csrf_token = csrf.generate_token @
        render: true

      POST: capture_errors =>
        csrf.assert_token @
        assert_valid @params, {
            { 'slug', exists: true, min_length: 3, max_length: 75 }
        }
        {:slug, :tags } = @params


        --tags = split tags ' '

        slug = slugify slug
        page = assert_error WikiPages\create slug

        redirect_to: @url_for("wikipage", slug: slug)
    }

    [search: "/search"]: =>
        assert_valid @params, {
            { 'q', exists: true, min_length: 1, max_length: 75 }
        }
        {:q} = @params
        @title = 'Search for ' .. q
        @query = q
        pq = q .. ':*'
        --res = db.query "SELECT * FROM wiki_pages WHERE to_tsvector(slug) @@ to_tsquery(?)", q .. ':*'
        --  select distinct on (wiki_page_id) r.* wiki_page_id from revisions r, wiki_pages w where r.wiki_page_id = w.id order by wiki_page_id, r.updated_at desc
        res = db.query [[select * from (select distinct on (r.wiki_page_id) r.*, w.id, w.slug from revisions r, wiki_pages w where r.wiki_page_id = w.id order by r.wiki_page_id, updated_at) as pages 
            WHERE 
                to_tsvector(slug) @@ to_tsquery(?) 
            OR
                to_tsvector(content) @@ to_tsquery(?)]], pq, pq
        if res
            @titlematches = res['resultset']
            unless @titlematches
                @titlematches = {}
            if #@titlematches == 1
                redirect_to: @url_for("wikipage", slug:@titlematches[1].slug)
        else
            @titlematches = {}
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

    "/db/make": =>
        schema = require "schema"
        schema.make_schema!
        json: { status: "ok" }

    --"/db/nuke": =>
    --    schema = require "schema"
    --    schema.destroy_schema!
    --    json: { status: "ok" }

    "/console": console.make!


