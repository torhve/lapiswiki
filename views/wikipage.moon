import Widget from require "lapis.html"

class New extends require "widgets.base"
    content: =>
        div class: "body", ->
          h2 class:"left title", @page.slug
          span class:"right", @page.updated_at
          raw '<br>'
          ul class:'right button-group', ->
              a href:'#', id:'edit', class:"button small alert", ->
                  i class:'foundicon-edit'
                  text 'Edit'
              a class:"button small", href:@url_for('revisions', slug:@page.slug),->
                  i class:'foundicon-clock'
                  text 'Revisions'
          raw '<hr>'

          @render_errors!

          unless next @revisions
              div contenteditable: 'true', class: "empty_message", 'Just start editing this content by clicking it. Easy peasy!'
              return


          for revision in *@revisions[1,1]
              div id:'wikipage',  ->
                raw revision.content
          raw [[
              <script>
              $('#edit').click(function(evt) {
                  console.log(evt);
                   $('#wikipage').attr('contenteditable', 'true');
                   CKEDITOR.inline( 'wikipage' );
              });
              </script>
            ]]
