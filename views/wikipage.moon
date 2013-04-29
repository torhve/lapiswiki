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
          raw [[
              <script>
              $('#edit').click(function(evt) {
                  evt.preventDefault();
                  $('#wikipage').attr('contenteditable', 'true');
                  var instance = CKEDITOR.inline( 'wikipage' );


              });
              </script>
            ]]

          @render_errors!

          unless next @revisions
              div id:'wikipage', class: "empty_message", ->
                  text "Click the Edit button to begin. Easy peasy! Don't panic!"
              return

            
          for revision in *@revisions[1,1]
              div id:'wikipage',  ->
                raw revision.content
