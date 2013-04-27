import Widget from require "lapis.html"

class Layout extends Widget
  content: =>
    html_5 ->
      head ->
        meta charset: "utf-8"
        title ->
          if @title
            text "#{@title} - LapisWiki"
          else
            text "LapisWiki"

        if @page_description
          meta name: "description", content: @page_description

        link rel: "stylesheet", href: "/static/css/normalize.css"
        link rel: "stylesheet", href: "/static/css/foundation.min.css"
        link rel: "stylesheet", href: "/static/style.css"
        -- script type: "text/javascript", src: "/static/main.js"
        script type: "text/javascript", src: "/static/ckeditor/ckeditor.js"
        raw [[
            <script>
		// This code is generally not necessary, but it is here to demonstrate
		// how to customize specific editor instances on the fly. This fits well
		// this demo because we have editable elements (like headers) that
		// require less features.

		// The "instanceCreated" event is fired for every editor instance created.
		CKEDITOR.on( 'instanceCreated', function( event ) {
			var editor = event.editor,
				element = editor.element;

			// Customize editors for headers and tag list.
			// These editors don't need features like smileys, templates, iframes etc.
			if ( element.is( 'h1', 'h2', 'h3' ) || element.getAttribute( 'id' ) == 'taglist' ) {
				// Customize the editor configurations on "configLoaded" event,
				// which is fired after the configuration file loading and
				// execution. This makes it possible to change the
				// configurations before the editor initialization takes place.
				editor.on( 'configLoaded', function() {

					// Remove unnecessary plugins to make the editor simpler.
					editor.config.removePlugins = 'colorbutton,find,flash,font,' +
						'forms,iframe,image,newpage,removeformat,' +
						'smiley,specialchar,stylescombo,templates';

					// Rearrange the layout of the toolbar.
					editor.config.toolbarGroups = [
						{ name: 'editing',		groups: [ 'basicstyles', 'links' ] },
						{ name: 'undo' },
						{ name: 'clipboard',	groups: [ 'selection', 'clipboard' ] },
						{ name: 'about' }
					];
				});
			}
		});
		CKEDITOR.on( 'blur', function( event ) {
			var editor = event.editor;
            var data = event.editor.getData();
            // Do sth with your data...
            console.log('data', data);
        });


	</script>
        ]]

      body ->
          nav class: "top-bar", ->
            ul class: "title-area", ->
                li class: "name", ->
                    h1 -> a href: @url_for"index", "LapisWiki"
                li class:"toggle-topbar menu-icon", ->
                    a href:"#", ->
                     span "Menu"
            section class: "top-bar-section", ->
                ul class:"left", ->
                    li class:"divider"
                    li class:"Home", ->
                      a href: @url_for("index"), "Home"
                    li class:"All", ->
                      a href: @url_for("all"), "All"
            section class: "top-bar-section", ->
                ul class:"right", ->
                    li class:"has-form", ->
                        form ->
                            div class:"row collapse", ->
                                div class:"small-8 columns", ->
                                    input type:"text", ->
                                div class:"small-4 columns", ->
                                    a href:"#", class:"alert button", 'Search'

                    li class:"divider"
                    li class:"", ->
                        a class: "button", href: @url_for"new", 'New'
                    li class:"divider"

          div class: "row content", ->
              div class: "large-12 columns", ->
                @content_for "inner"

    div class: "prefooter", ->
      div class: "row", ->
          div class: "large-12 columns", ->
              div class: "right", ->
                text ""
              raw "&nbsp;"
    div class: "footer", ->
      div class: "row", ->
          div class: "large-12 columns", ->
              div class: "right", ->
                text "by "
                a href: "http://twitter.com/thveem", "@thveem"
                raw " &middot; "
                a href: "http://github.com/torhve/lapiswiki", "Source"

              a href: @url_for("index"), "Home"
              raw " &middot; "
