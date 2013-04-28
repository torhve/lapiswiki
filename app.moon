http = require "lapis.nginx.http"
db = require "lapis.nginx.postgres"
lapis = require "lapis.init"
csrf = require "lapis.csrf"
console = require "lapis.console"

import respond_to, capture_errors, assert_error, yield_error from require "lapis.application"
import validate, assert_valid from require "lapis.validate"
import escape_pattern, trim_filter, slugify from require "lapis.util"

import WikiPages, Revisions from require "models"

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
        page = assert_error WikiPages\create slug
        redirect_to: @url_for("wikipage", slug:slugify slug)
    }

    [search: "/search"]: capture_errors =>
        {:q} = @params
        @page_title = 'Search for ' .. q
        @query = q
        res = db.query "SELECT * FROM wiki_pages WHERE to_tsvector(slug) @@ to_tsquery(?)", q
        @titlematches = res['resultset']
        if #@titlematches == 1
            redirect_to: @url_for("wikipage", slug:@titlematches[1].slug)
        else
            render: true

    --"/db/make": =>
    --    schema = require "schema"
    --    schema.make_schema!
    --    json: { status: "ok" }

    --"/db/nuke": =>
    --    schema = require "schema"
    --    schema.destroy_schema!
    --    json: { status: "ok" }

    "/console": console.make!


