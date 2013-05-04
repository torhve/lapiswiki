import Widget from require "lapis.html"

class New extends require "widgets.base"
    content: =>
        div class: "body", ->
          h2 @title

          unless next @pages
              div class: "empty_message", 'No wiki pages found!'
              return


          for page in *@pages
              div ->
                  a href:@url_for("wikipage", slug: page.slug), ->
                    i class:'foundicon-page', ' '
                    text page.slug
