import Widget from require "lapis.html"

class Base extends Widget
  term_snippet: (cmd) =>
    pre class: "highlight lang_bash term_snippet", ->
      code ->
        span class: "nv", "$ "
        text cmd

  render_errors: =>
    if @errors
      div "Errors:"
      ul ->
        for e in *@errors
          li e
