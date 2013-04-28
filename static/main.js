// This code is generally not necessary, but it is here to demonstrate
// how to customize specific editor instances on the fly. This fits well
// this demo because we have editable elements (like headers) that
// require less features.
// fugly global XXX
var editor;
// The "instanceCreated" event is fired for every editor instance created.
CKEDITOR.on( 'instanceCreated', function( event ) {
    editor = event.editor;
    var element = editor.element;

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
/*
CKEDITOR.on( 'instanceReady', function( event ) {
    editor = event.editor;
    periodicData();
});
CKEDITOR.on( 'blur', function( event ) {
    var editor = event.editor;
    var data = event.editor.getData();
    // Do sth with your data...
    console.log('data', data);
});

CKEDITOR.disableAutoInline = true;
var editor = CKEDITOR.inline( 'editable', {
    on: {
        instanceReady: function() {
            periodicData();
        }
    }
} );

var periodicData = ( function(){
    var data, oldData = editor.getData();

    return function() {
        if ( ( data = editor.getData() ) !== oldData ) {
            oldData = data;
            console.log( 'changed data', data );
            $.ajax({
                type: 'post',
                data: {'content': data},
                success: function(data) {
                    console.log( 'Saved OK' );

                },
                error: function(data){
                    console.log('Error with saving!');
                }
            });
        }

        setTimeout( periodicData, 1000 );
    };
})();
*/
