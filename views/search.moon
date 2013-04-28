import Widget from require "lapis.html"

class New extends require "widgets.base"
    content: =>
        div class: "body", ->
          h2 class:"left", 'Search for "', ->
              i @query
              text '"'
          raw '<hr>'

          @render_errors!

          unless next @titlematches
              div class: "empty_message", 'No title matches found.'
          for page in *@titlematches
              div ->
                  a href:@url_for("wikipage", slug: page.slug), page.slug


