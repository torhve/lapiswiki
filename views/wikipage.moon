import Widget from require "lapis.html"

class New extends require "widgets.base"
    content: =>
        div class: "body", ->
          h2 class:"left title", @page.slug
          span class:"right", @page.updated_at
          raw '<br>'
          a class:"right button tiny", href:@url_for('revisions', slug:@page.slug),->
              text 'Revisions'
          raw '<hr>'

          @render_errors!

          unless next @revisions
              div contenteditable: 'true', class: "empty_message", 'Just start editing this content by clicking it. Easy peasy!'
              return


          for revision in *@revisions
              div contenteditable: 'true', ->
                raw revision.content
              return
