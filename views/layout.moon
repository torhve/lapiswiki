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
        script type: "text/javascript", src: "//ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js"
        script type: "text/javascript", src: "/static/ckeditor/ckeditor.js"
        script type: "text/javascript", src: "/static/main.js"

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
                      a href: @url_for("all"), "All pages"
                    li class:"recent", ->
                      a href: @url_for("recent"), "Recent changes"
            section class: "top-bar-section", ->
                ul class:"right", ->
                    li class:"has-form", ->
                        form action:"/search", method:"get", ->
                            div class:"row collapse", ->
                                div class:"small-8 columns", ->
                                    input name:"q", type:"text", ->
                                div class:"small-4 columns", ->
                                    input type:"submit", class:"alert button",value:'Search'

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

