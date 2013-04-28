import Widget from require "lapis.html"
class Index extends Widget
    content: =>
        div class: "body", ->
            h1  @page_title
            div contenteditable:"true", ->
                raw [[
                Lapis Wiki is a very simple demo application built using <a href="http://leafo.net/lapis/">Lapis</a> and <a href="http://ckeditor.com/">CKEditor</a>. Primary motivation for building was playing with the Lapis framework, and also making a proof of fconcept of a Wiki that can accept pasted images. Hello, it's 2013, browsers have capabilities yet wikis do not.
                <p>You can edit this content too test the editor</p>
                <p>This wiki has almost no features at all! It can barely even save content.</p>
                <h2>Lapis lazuli</h2>
                <a href="http://en.wikipedia.org/wiki/Lapis_lazuli">
                <img src="http://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Lapis_lazuli_block.jpg/225px-Lapis_lazuli_block.jpg">
                </a>
                
]]
