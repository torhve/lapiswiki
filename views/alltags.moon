import Widget from require "lapis.html"

class New extends require "widgets.base"
    content: =>
        div class: "body", ->
          h2 "All wiki tags"

          unless next @tags
              div class: "empty_message", 'No tags found!'
              return


          for tag in *@tags
              div ->
                  a class:'title', href:@url_for("tag", name: tag.name), tag.name
