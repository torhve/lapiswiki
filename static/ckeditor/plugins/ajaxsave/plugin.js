var saveCmd = {
    modes : { wysiwyg:1 },
    exec : function( editor ) {
        var $content = editor.getData();
        var feedbackel = $('<div class=alert-box data-alert></div>');
        $('.body').append(feedbackel);

        feedbackel.html('Saving ...')

        $.ajax({
            type: 'post',
            data: {'content': $content},
            success: function(data) {
                feedbackel.addClass('success').html('Saved OK')
                console.log( 'Saved OK' );

            },
            error: function(data){
                console.log('Error with saving!');
                feedbackel.addClass('alert').html('Error when saving content!')
            }
        });
        // Clear msg after a while
        feedbackel.fadeOut(1000, function() {$(this).remove();});
        /*
        $.ajax({
            type: 'post',
            url: '../../upload/',
            data: $data,
            dataType: 'json',
            cache: false,
            success: function(data) {

                    alert( 'OK' );

            },
            error: function(data){
                alert('fatal error');
            }
        });
       CKEDITOR.instances.editor1.destroy();
        */
   }

}
CKEDITOR.plugins.add('ajaxsave',  {    

    init:function(editor) {

        var pluginName = 'ajaxsave';
        var command = editor.addCommand(pluginName,saveCmd);
        command.modes = {wysiwyg:1 };   

        editor.ui.addButton('ajaxsave', {
            label: 'Save text',
            command: pluginName,
            toolbar: 'undo,1',
            icon: this.path+'save.png'
        });
    }
});
