import Widget from require "lapis.html"

class New extends require "widgets.base"
    content: =>
        div class: "body", ->
          h2 @page_title
          @render_errors!

          form method: "POST", action: @url_for("new"), ->
            input type: "hidden", name: "csrf_token", value: @csrf_token
            div class: "row", ->
            label for: "slug_field", "Document name"
            input type: "text", name: "slug", id: "slug_field"
            --label for: "tag_field", "Space separated list of tags/categories. (e.g. linux, windows, network, etc)"
            --input type: "text", name: "tags", id: "tag_field"
            div ->
                input type: "submit", class: "button primary", value:'Create document'
