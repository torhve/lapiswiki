import Widget from require "lapis.html"

class New extends require "widgets.base"
    content: =>
        div class: "body", ->
          h2 class:"left title", @page.slug
          small class:"right", @page.updated_at
          raw '<hr>'

          @render_errors!

          unless next @revisions
              div contenteditable: 'true', class: "empty_message", 'No revisions found'
              return

          form ->
              element 'table', ->
                th ''
                th 'Revision'
                th 'When'
                th 'Who'
                th 'Size'
                  
                for revision in *@revisions
                    tr ->
                      td ->
                        input type:'checkbox', name:'selected', id:revision.id
                      td ->
                        a href:@url_for('wikipage', slug: @page.slug)..'?revision='..revision.id, ->
                            raw @page.slug
                            raw ' - '
                            raw revision.id
                      td ->
                        raw revision.created_at
                      td ->
                        raw revision.creator_ip
                      td ->
                        raw #revision.content
                        raw ' characters '
              input class:'button small', type:'submit', value:'Compare revisions', onclick:'alert("Not yet implemented")'
          
