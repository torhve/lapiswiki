import Widget from require "lapis.html"

class New extends require "widgets.base"
    content: =>
        div class: "body", ->
          h2 "Recent changes"

          unless next @pages
              div class: "empty_message", 'No wiki pages found!'
              return


          for page in *@pages
              div ->
                  a href:@url_for("wikipage", slug: page.slug), page.slug
                  raw ' &middot; '
                  raw page.updated_at
                  raw ' &middot; '
                  raw page.creator_ip
