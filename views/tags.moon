import Widget from require "lapis.html"

class New extends require "widgets.base"
    content: =>
        div class: "body", ->
          h2 class:"left title", @page.slug
          small class:"right", @page.updated_at
          raw '<hr>'

          @render_errors!

          unless next @tags
              div contenteditable: 'true', class: "empty_message", 'No tags for this document yet.'

          ul ->
          for tag in *@tags
              li ->
                raw ' '
                a class:"title", href:@url_for('tag', name: tag.name), ->
                    raw tag.name

          form method:'post', ->
              input type:'text', name:'name'
              input class:'button small', type:'submit', value:'Add new tag'

          
