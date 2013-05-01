import Widget from require "lapis.html"

class New extends require "widgets.base"
  content: =>
    div class: "body", ->
      h2 "Recent changes"

      unless next @pages
        div class: "empty_message", 'No wiki pages found!'
        return

      
      element "table", ->
        th 'Document'
        th 'When'
        th 'Who'

        for page in *@pages
          tr ->
            td ->
              a href:@url_for("wikipage", slug: page.slug), page.slug
            td ->
              raw page.updated_at
            td ->
              raw page.creator_ip
