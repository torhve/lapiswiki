/*
 * @file image paste plugin for CKEditor
	Feature introduced in: https://bugzilla.mozilla.org/show_bug.cgi?id=490879
	doesn't include images inside HTML (paste from word): https://bugzilla.mozilla.org/show_bug.cgi?id=665341
 * Copyright (C) 2011 Alfonso Martínez de Lizarrondo
 * Copyright (C) 2013 Tor Hveem
 *
 * == BEGIN LICENSE ==
 *
 * Licensed under the terms of any of the following licenses at your
 * choice:
 *
 *  - GNU General Public License Version 2 or later (the "GPL")
 *    http://www.gnu.org/licenses/gpl.html
 *
 *  - GNU Lesser General Public License Version 2.1 or later (the "LGPL")
 *    http://www.gnu.org/licenses/lgpl.html
 *
 *  - Mozilla Public License Version 1.1 or later (the "MPL")
 *    http://www.mozilla.org/MPL/MPL-1.1.html
 *
 * == END LICENSE ==
 *
 */

 // Handles image pasting in Firefox
CKEDITOR.plugins.add( 'imagepaste',
{
	init : function( editor )
	{

		editor.on( 'contentDom', function(e) {
            // Register binary handler
            XMLHttpRequest.prototype.sendAsBinary = function(datastr) {
                function byteValue(x) {
                    return x.charCodeAt(0) & 0xff;
                }
                var ords = Array.prototype.map.call(datastr, byteValue);
                var ui8a = new Uint8Array(ords);
                this.send(ui8a.buffer);
            }

            // Register on paste handler for webkit
            document.onpaste = function(event){
                var items = event.clipboardData.items;
                //console.log(JSON.stringify(items)); // will give you the mime types
                var blob = items[0].getAsFile();
                var reader = new FileReader();
                reader.onload = function(event){
					var id = CKEDITOR.tools.getNextId();
                    var data = event.target.result;
					data = data.split(',')[1];
					var url = editor.config.filebrowserImageUploadUrl + '&CKEditor=' + editor.name + '&CKEditorFuncNum=2&langCode=' + editor.langCode;

					var xhr = new XMLHttpRequest();

					xhr.open("POST", url);
					xhr.onload = function() {
						// Upon finish, get the url and update the file
						var imageUrl = xhr.responseText.match(/2,\s*'(.*?)',/)[1];
                        console.log('imageurl', imageUrl);
                        CKEDITOR.instances[editor.name].insertHtml('<img src="'+imageUrl+'" alt="">');
					}

					// Create the multipart data upload. Is it possible somehow to use FormData instead?
					var BOUNDARY = "---------------------------1966284435497298061834782736";
					var rn = "\r\n";
					var req = "--" + BOUNDARY;

					  req += rn + "Content-Disposition: form-data; name=\"upload\"";

						var bin = window.atob( data );
						// add timestamp?
						req += "; filename=\"" + id + ".png\"" + rn + "Content-type: image/png";

						req += rn + rn + bin + rn + "--" + BOUNDARY;

					req += "--";

					xhr.setRequestHeader("Content-Type", "multipart/form-data; boundary=" + BOUNDARY);
					xhr.sendAsBinary(req);
                }; // data url!
                reader.readAsDataURL(blob);
            }

        });
		// Paste from clipboard:
		editor.on( 'paste', function(e) {

            var type = e.data.type;
			if (type != 'html')
				return;
            var html = e.data.dataValue;

            // Replace data: images in Firefox and upload them
			e.data.dataValue = html.replace( /<img src="data:image\/png;base64,.*?" alt="">/g, function( img )
				{
					var data = img.match(/"data:image\/png;base64,(.*?)"/)[1];
					var id = CKEDITOR.tools.getNextId();

					var url= editor.config.filebrowserImageUploadUrl + '&CKEditor=' + editor.name + '&CKEditorFuncNum=2&langCode=' + editor.langCode;

					var xhr = new XMLHttpRequest();

					xhr.open("POST", url);
					xhr.onload = function() {
						// Upon finish, get the url and update the file
						var imageUrl = xhr.responseText.match(/2,\s*'(.*?)',/)[1];
						var theImage = editor.document.getById( id );
						theImage.data( 'cke-saved-src', imageUrl);
						theImage.setAttribute( 'src', imageUrl);
						theImage.removeAttribute( 'id' );
					}

					// Create the multipart data upload. Is it possible somehow to use FormData instead?
					var BOUNDARY = "---------------------------1966284435497298061834782736";
					var rn = "\r\n";
					var req = "--" + BOUNDARY;

					  req += rn + "Content-Disposition: form-data; name=\"upload\"";

						var bin = window.atob( data );
						// add timestamp?
						req += "; filename=\"" + id + ".png\"" + rn + "Content-type: image/png";

						req += rn + rn + bin + rn + "--" + BOUNDARY;

					req += "--";

					xhr.setRequestHeader("Content-Type", "multipart/form-data; boundary=" + BOUNDARY);
					xhr.sendAsBinary(req);

					var replaced =  img.replace(/<img /, '<img id="' + id + '" ')
                    return replaced;

				});
		});

	} //Init
} );
