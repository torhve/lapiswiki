import Widget from require "lapis.html"

class New extends require "widgets.base"
    content: =>
        div class: "body", ->
          h2 @page.slug
          small class:"right", @page.updated_at

          @render_errors!

          unless next @revisions
              div contenteditable: 'true', class: "empty_message", 'Just start editing this content by clicking it. Easy peasy!'
              return


          for revision in *revisions
              div contenteditable: 'true', revision.content
              return
