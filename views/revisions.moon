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
              ul ->
              for revision in *@revisions
                  li ->
                    input type:'checkbox', name:'selected', id:revision.id
                    raw ' '
                    a href:@url_for('wikipage', slug: @page.slug)..'?revision='..revision.id, ->
                        raw @page.slug
                        raw ' - '
                        raw revision.id
                    raw ' &middot; '
                    raw revision.created_at
                    raw ' &middot; '
                    raw revision.creator_ip
                    raw ' &middot; '
                    raw #revision.content
                    raw ' characters '
              input class:'button small', type:'submit', value:'Compare revisions', onclick:'alert("Not yet implemented")'
          
