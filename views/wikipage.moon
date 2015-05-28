import Widget from require "lapis.html"

class WikiPage extends require "widgets.base"
    content: =>
        div class: "body", ->
          h2 class:"left title", @page.slug
          if @revisions
            span class:"right label", "Changed #{@revisions[1].updated_at} "
          else
            span class:"right", " Created #{@page.updated_at} "
          raw '<br>'
          ul class:'right button-group', ->
              a href:'#', id:'edit', class:"button small alert", ->
                  i class:'foundicon-edit'
                  text ' '
                  text 'Edit'
              a href:'#', id:'save', style:"display:none;", class:"button small alert", ->
                  i class:'foundicon-edit'
                  text ' '
                  text 'Save'
              a class:"button small", href:@url_for('tags', slug:@page.slug),->
                  i class:'foundicon-flag'
                  text ' '
                  text 'Edit tags'
              a class:"button small", href:@url_for('revisions', slug:@page.slug),->
                  i class:'foundicon-clock'
                  text ' '
                  text 'Revisions'


          raw '<br style="clear: both;">'
          if #@tags > 0
              h6, 'Tags'
          ul class:'inline-list', ->
              for tag in *@tags
                  li ->
                    a href:@url_for('tag', name:tag.name), ->
                        i class:'foundicon-flag', ' '
                        text tag.name
          raw '<hr>'

          @render_errors!

          unless next @revisions
              div id:'wikipage', class: "empty_message", ->
                  text "Click the Edit button to begin. Easy peasy! Don't panic!"
          else
              for revision in *@revisions[1,1]
                  div id:'wikipage',  ->
                    raw revision.content
          
          raw '<hr>'
          raw [[
              <script>
              $('#edit').click(function(evt) {
                  evt.preventDefault();
                  $('#edit').hide();
                  $('#save').show();
                  $('#wikipage').attr('contenteditable', 'true');
                  var instance = CKEDITOR.inline( 'wikipage' );
              });
              $('#save').click(function(evt) {
                  evt.preventDefault();
                  $('#wikipage').attr('contenteditable', 'false');
                  CKEDITOR.instances['wikipage'].commands.ajaxsave.exec();
                  $('#save').hide();
                  $('#edit').show();
              });
              </script>
            ]]
