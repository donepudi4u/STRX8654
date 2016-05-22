<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WYSIWYG</title>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="scripts/wysiwyg.js"></script>
<script type="text/javascript" src="scripts/wysiwyg-editor.js"></script>
<!-- github.io delivers wrong content-type - but you may want to include FontAwesome in 'wysiwyg-editor.css' -->
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="media/dataTables/wysiwyg-editor.css" />
<script type="text/javascript">
$(document).ready(function() {
    // Featured editor
    $('#editor1,#editor2,#editor3').each( function(index, element)
    {
        $(element).wysiwyg({
            'class': index === 0 ? 'fake-bootstrap' : (index === 1 ? 'fake-uikit' : 'some-more-classes'),
            // 'selection'|'top'|'top-selection'|'bottom'|'bottom-selection'
            toolbar: index === 0 ? 'top-selection' : (index === 1 ? 'bottom-focus' : 'selection'),
            buttons: {
                // Dummy-HTML-Plugin
                dummybutton1: index !== 1 ? false : {
                    html: $('<input id="submit" type="button" value="Submit" />').click(function() {
                                alert( 'Submit form' );
                            }),
                    //showstatic: true,    // wanted on the toolbar
                    showselection: false    // wanted on selection
                },
                // Dummy-Button-Plugin
                dummybutton2: index !== 1 ? false : {
                    title: 'Dummy',
                    image: '\uf1e7',
                    click: function( $button ) {
                                // We simply make 'bold'
                                if( $(element).wysiwyg('shell').getSelectedHTML() )
                                    $(element).wysiwyg('shell').bold();
                                else
                                    alert( 'No text selected' );
                           },
                    //showstatic: true,    // wanted on the toolbar
                    showselection: false    // wanted on selection
                },
                // Smiley plugin
                smilies: {
                    title: 'Smilies',
                    image: '\uf118', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    popup: function( $popup, $button ) {
                            var list_smilies = [
                                    '<img src="smiley/afraid.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/amorous.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/angel.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/angry.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/bored.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/cold.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/confused.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/cross.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/crying.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/devil.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/disappointed.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/dont-know.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/drool.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/embarrassed.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/excited.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/excruciating.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/eyeroll.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/happy.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/hot.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/hug-left.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/hug-right.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/hungry.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/invincible.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/kiss.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/lying.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/meeting.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/nerdy.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/neutral.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/party.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/pirate.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/pissed-off.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/question.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/sad.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/shame.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/shocked.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/shut-mouth.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/sick.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/silent.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/sleeping.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/sleepy.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/stressed.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/thinking.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/tongue.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/uhm-yeah.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/wink.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/working.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/bathing.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/beer.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/boy.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/camera.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/chilli.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/cigarette.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/cinema.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/coffee.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/girl.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/console.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/grumpy.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/in_love.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/internet.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/lamp.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/mobile.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/mrgreen.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/musical-note.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/music.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/phone.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/plate.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/restroom.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/rose.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/search.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/shopping.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/star.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/studying.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/suit.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/surfing.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/thunder.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/tv.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/typing.png" width="16" height="16" alt="" />',
                                    '<img src="smiley/writing.png" width="16" height="16" alt="" />'
                            ];
                            var $smilies = $('<div/>').addClass('wysiwyg-plugin-smilies')
                                                      .attr('unselectable','on');
                            $.each( list_smilies, function(index,smiley) {
                                if( index !== 0 )
                                    $smilies.append(' ');
                                var $image = $(smiley).attr('unselectable','on');
                                // Append smiley
                                var imagehtml = ' '+$('<div/>').append($image.clone()).html()+' ';
                                $image
                                    .css({ cursor: 'pointer' })
                                    .click(function(event) {
                                        $(element).wysiwyg('shell').insertHTML(imagehtml); // .closePopup(); - do not close the popup
                                    })
                                    .appendTo( $smilies );
                            });
                            var $container = $(element).wysiwyg('container');
                            $smilies.css({ maxWidth: parseInt($container.width()*0.95)+'px' });
                            $popup.append( $smilies );
                            // Smilies do not close on click, so force the popup-position to cover the toolbar
                            var $toolbar = $button.parents( '.wysiwyg-toolbar' );
                            if( ! $toolbar.length ) // selection toolbar?
                                return ;
                            return { // this prevents applying default position
                                left: parseInt( ($toolbar.outerWidth() - $popup.outerWidth()) / 2 ),
                                top: $toolbar.hasClass('wysiwyg-toolbar-bottom') ? ($container.outerHeight() - parseInt($button.outerHeight()/4)) : (parseInt($button.outerHeight()/4) - $popup.height())
                            };
                           },
                    //showstatic: true,    // wanted on the toolbar
                    showselection: index === 2 ? true : false    // wanted on selection
                },
                insertimage: {
                    title: 'Insert image',
                    image: '\uf030', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    //showstatic: true,    // wanted on the toolbar
                    showselection: index === 2 ? true : false    // wanted on selection
                },
                insertvideo: {
                    title: 'Insert video',
                    image: '\uf03d', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    //showstatic: true,    // wanted on the toolbar
                    showselection: index === 2 ? true : false    // wanted on selection
                },
                insertlink: {
                    title: 'Insert link',
                    image: '\uf08e' // <img src="path/to/image.png" width="16" height="16" alt="" />
                },
                // Fontname plugin
                fontname: index === 1 ? false : {
                    title: 'Font',
                    image: '\uf031', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    popup: function( $popup, $button ) {
                            var list_fontnames = {
                                    // Name : Font
                                    'Arial, Helvetica' : 'Arial,Helvetica',
                                    'Verdana'          : 'Verdana,Geneva',
                                    'Georgia'          : 'Georgia',
                                    'Courier New'      : 'Courier New,Courier',
                                    'Times New Roman'  : 'Times New Roman,Times'
                                };
                            var $list = $('<div/>').addClass('wysiwyg-plugin-list')
                                                   .attr('unselectable','on');
                            $.each( list_fontnames, function( name, font ) {
                                var $link = $('<a/>').attr('href','#')
                                                    .css( 'font-family', font )
                                                    .html( name )
                                                    .click(function(event) {
                                                        $(element).wysiwyg('shell').fontName(font).closePopup();
                                                        // prevent link-href-#
                                                        event.stopPropagation();
                                                        event.preventDefault();
                                                        return false;
                                                    });
                                $list.append( $link );
                            });
                            $popup.append( $list );
                           },
                    //showstatic: true,    // wanted on the toolbar
                    showselection: index === 0 ? true : false    // wanted on selection
                },
                // Fontsize plugin
                fontsize: index !== 1 ? false : {
                    title: 'Size',
                    style: 'color:white;background:red',      // you can pass any property - example: "style"
                    image: '\uf034', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    popup: function( $popup, $button ) {
                            // Hack: http://stackoverflow.com/questions/5868295/document-execcommand-fontsize-in-pixels/5870603#5870603
                            var list_fontsizes = [];
                            for( var i=8; i <= 11; ++i )
                                list_fontsizes.push(i+'px');
                            for( var i=12; i <= 28; i+=2 )
                                list_fontsizes.push(i+'px');
                            list_fontsizes.push('36px');
                            list_fontsizes.push('48px');
                            list_fontsizes.push('72px');
                            var $list = $('<div/>').addClass('wysiwyg-plugin-list')
                                                   .attr('unselectable','on');
                            $.each( list_fontsizes, function( index, size ) {
                                var $link = $('<a/>').attr('href','#')
                                                    .html( size )
                                                    .click(function(event) {
                                                        $(element).wysiwyg('shell').fontSize(7).closePopup();
                                                        $(element).wysiwyg('container')
                                                                .find('font[size=7]')
                                                                .removeAttr("size")
                                                                .css("font-size", size);
                                                        // prevent link-href-#
                                                        event.stopPropagation();
                                                        event.preventDefault();
                                                        return false;
                                                    });
                                $list.append( $link );
                            });
                            $popup.append( $list );
                           }
                    //showstatic: true,    // wanted on the toolbar
                    //showselection: true    // wanted on selection
                },
                // Header plugin
                header: index !== 1 ? false : {
                    title: 'Header',
                    style: 'color:white;background:blue',      // you can pass any property - example: "style"
                    image: '\uf1dc', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    popup: function( $popup, $button ) {
                            var list_headers = {
                                    // Name : Font
                                    'Header 1' : '<h1>',
                                    'Header 2' : '<h2>',
                                    'Header 3' : '<h3>',
                                    'Header 4' : '<h4>',
                                    'Header 5' : '<h5>',
                                    'Header 6' : '<h6>',
                                    'Code'     : '<pre>'
                                };
                            var $list = $('<div/>').addClass('wysiwyg-plugin-list')
                                                   .attr('unselectable','on');
                            $.each( list_headers, function( name, format ) {
                                var $link = $('<a/>').attr('href','#')
                                                     .css( 'font-family', format )
                                                     .html( name )
                                                     .click(function(event) {
                                                        $(element).wysiwyg('shell').format(format).closePopup();
                                                        // prevent link-href-#
                                                        event.stopPropagation();
                                                        event.preventDefault();
                                                        return false;
                                                    });
                                $list.append( $link );
                            });
                            $popup.append( $list );
                           }
                    //showstatic: true,    // wanted on the toolbar
                    //showselection: false    // wanted on selection
                },
                bold: {
                    title: 'Bold (Ctrl+B)',
                    image: '\uf032',  <img src="media/images/bold.png" width="16" height="16" alt="" />
                    hotkey: 'b'
                },
                italic: {
                    title: 'Italic (Ctrl+I)',
                    image: '\uf033', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    hotkey: 'i'
                },
                underline: {
                    title: 'Underline (Ctrl+U)',
                    image: '\uf0cd', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    hotkey: 'u'
                },
                strikethrough: {
                    title: 'Strikethrough (Ctrl+S)',
                    image: '\uf0cc', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    hotkey: 's'
                },
                forecolor: {
                    title: 'Text color',
                    image: '\uf1fc' // <img src="path/to/image.png" width="16" height="16" alt="" />
                },
                highlight: {
                    title: 'Background color',
                    image: '\uf043' // <img src="path/to/image.png" width="16" height="16" alt="" />
                },
                alignleft: index !== 0 ? false : {
                    title: 'Left',
                    image: '\uf036', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    //showstatic: true,    // wanted on the toolbar
                    showselection: false    // wanted on selection
                },
                aligncenter: index !== 0 ? false : {
                    title: 'Center',
                    image: '\uf037', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    //showstatic: true,    // wanted on the toolbar
                    showselection: false    // wanted on selection
                },
                alignright: index !== 0 ? false : {
                    title: 'Right',
                    image: '\uf038', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    //showstatic: true,    // wanted on the toolbar
                    showselection: false    // wanted on selection
                },
                alignjustify: index !== 0 ? false : {
                    title: 'Justify',
                    image: '\uf039', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    //showstatic: true,    // wanted on the toolbar
                    showselection: false    // wanted on selection
                },
                subscript: index === 1 ? false : {
                    title: 'Subscript',
                    image: '\uf12c', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    //showstatic: true,    // wanted on the toolbar
                    showselection: true    // wanted on selection
                },
                superscript: index === 1 ? false : {
                    title: 'Superscript',
                    image: '\uf12b', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    //showstatic: true,    // wanted on the toolbar
                    showselection: true    // wanted on selection
                },
                indent: index !== 0 ? false : {
                    title: 'Indent',
                    image: '\uf03c', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    //showstatic: true,    // wanted on the toolbar
                    showselection: false    // wanted on selection
                },
                outdent: index !== 0 ? false : {
                    title: 'Outdent',
                    image: '\uf03b', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    //showstatic: true,    // wanted on the toolbar
                    showselection: false    // wanted on selection
                },
                orderedList: index !== 0 ? false : {
                    title: 'Ordered list',
                    image: '\uf0cb', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    //showstatic: true,    // wanted on the toolbar
                    showselection: false    // wanted on selection
                },
                unorderedList: index !== 0 ? false : {
                    title: 'Unordered list',
                    image: '\uf0ca', // <img src="path/to/image.png" width="16" height="16" alt="" />
                    //showstatic: true,    // wanted on the toolbar
                    showselection: false    // wanted on selection
                },
                removeformat: {
                    title: 'Remove format',
                    image: '\uf12d' // <img src="path/to/image.png" width="16" height="16" alt="" />
                }
            },
            // Submit-Button
            submit: {
                title: 'Submit',
                image: '\uf00c' // <img src="path/to/image.png" width="16" height="16" alt="" />
            },
            // Other properties
            selectImage: 'Click or drop image',
            placeholderUrl: 'www.example.com',
            placeholderEmbed: '<embed/>',
            maxImageSize: [600,200],
            //filterImageType: callback( file ) {},
            onKeyDown: function( key, character, shiftKey, altKey, ctrlKey, metaKey ) {
                            // E.g.: submit form on enter-key:
                            //if( (key == 10 || key == 13) && !shiftKey && !altKey && !ctrlKey && !metaKey ) {
                            //    submit_form();
                            //    return false; // swallow enter
                            //}
                        },
            onKeyPress: function( key, character, shiftKey, altKey, ctrlKey, metaKey ) {
                        },
            onKeyUp: function( key, character, shiftKey, altKey, ctrlKey, metaKey ) {
                        },
            onAutocomplete: function( typed, key, character, shiftKey, altKey, ctrlKey, metaKey ) {
                            if( typed.indexOf('@') === 0 ) // startswith '@'
                            {
                                var usernames = [
                                        'Evelyn',
                                        'Harry',
                                        'Amelia',
                                        'Oliver',
                                        'Isabelle',
                                        'Eddie',
                                        'Editha',
                                        'Jacob',
                                        'Emily',
                                        'George',
                                        'Edison'
                                    ];
                                var $list = $('<div/>').addClass('wysiwyg-plugin-list')
                                                       .attr('unselectable','on');
                                $.each( usernames, function( index, username ) {
                                    if( username.toLowerCase().indexOf(typed.substring(1).toLowerCase()) !== 0 ) // don't count first character '@'
                                        return;
                                    var $link = $('<a/>').attr('href','#')
                                                        .text( username )
                                                        .click(function(event) {
                                                            var url = 'http://example.com/user/' + username,
                                                                html = '<a href="' + url + '">@' + username + '</a> ';
                                                            var editor = $(element).wysiwyg('shell');
                                                            // Expand selection and set inject HTML
                                                            editor.expandSelection( typed.length, 0 ).insertHTML( html );
                                                            editor.closePopup().getElement().focus();
                                                            // prevent link-href-#
                                                            event.stopPropagation();
                                                            event.preventDefault();
                                                            return false;
                                                        });
                                    $list.append( $link );
                                });
                                if( $list.children().length )
                                {
                                    if( key === 13 )
                                    {
                                        $list.children(':first').click();
                                        return false; // swallow enter
                                    }
                                    // Show popup
                                    else if( character || key === 8 )
                                        return $list;
                                }
                            }
                        },
            onImageUpload: function( insert_image ) {
                            // A bit tricky, because we can't easily upload a file via
                            // '$.ajax()' on a legacy browser without XMLHttpRequest2.
                            // You have to submit the form into an '<iframe/>' element.
                            // Call 'insert_image(url)' as soon as the file is online
                            // and the URL is available.
                            // Example server script (written in PHP):
                            /*
                            <?php
                            $upload = $_FILES['upload-filename'];
                            // Crucial: Forbid code files
                            $file_extension = pathinfo( $upload['name'], PATHINFO_EXTENSION );
                            if( $file_extension != 'jpeg' && $file_extension != 'jpg' && $file_extension != 'png' && $file_extension != 'gif' )
                                die("Wrong file extension.");
                            $filename = 'image-'.md5(microtime(true)).'.'.$file_extension;
                            $filepath = '/path/to/'.$filename;
                            $serverpath = 'http://domain.com/path/to/'.$filename;
                            move_uploaded_file( $upload['tmp_name'], $filepath );
                            echo $serverpath;
                            */
                            // Example client script (without upload-progressbar):
                            var iframe_name = 'legacy-uploader-' + Math.random().toString(36).substring(2);
                            $('<iframe>').attr('name',iframe_name)
                                         .load(function() {
                                            // <iframe> is ready - we will find the URL in the iframe-body
                                            var iframe = this;
                                            var iframedoc = iframe.contentDocument ? iframe.contentDocument :
                                                           (iframe.contentWindow ? iframe.contentWindow.document : iframe.document);
                                            var iframebody = iframedoc.getElementsByTagName('body')[0];
                                            var image_url = iframebody.innerHTML;
                                            insert_image( image_url );
                                            $(iframe).remove();
                                         })
                                         .appendTo(document.body);
                            var $input = $(this);
                            $input.attr('name','upload-filename')
                                  .parents('form')
                                  .attr('action','/script.php') // accessing cross domain <iframes> could be difficult
                                  .attr('method','POST')
                                  .attr('enctype','multipart/form-data')
                                  .attr('target',iframe_name)
                                  .submit();
                        },
            forceImageUpload: false,    // upload images even if File-API is present
            videoFromUrl: function( url ) {
                // Contributions are welcome :-)

                // youtube - http://stackoverflow.com/questions/3392993/php-regex-to-get-youtube-video-id
                var youtube_match = url.match( /^(?:http(?:s)?:\/\/)?(?:[a-z0-9.]+\.)?(?:youtu\.be|youtube\.com)\/(?:(?:watch)?\?(?:.*&)?v(?:i)?=|(?:embed|v|vi|user)\/)([^\?&\"'>]+)/ );
                if( youtube_match && youtube_match[1].length === 11 )
                    return '<iframe src="//www.youtube.com/embed/' + youtube_match[1] + '" width="640" height="360" frameborder="0" allowfullscreen></iframe>';

                // vimeo - http://embedresponsively.com/
                var vimeo_match = url.match( /^(?:http(?:s)?:\/\/)?(?:[a-z0-9.]+\.)?vimeo\.com\/([0-9]+)$/ );
                if( vimeo_match )
                    return '<iframe src="//player.vimeo.com/video/' + vimeo_match[1] + '" width="640" height="360" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>';

                // dailymotion - http://embedresponsively.com/
                var dailymotion_match = url.match( /^(?:http(?:s)?:\/\/)?(?:[a-z0-9.]+\.)?dailymotion\.com\/video\/([0-9a-z]+)$/ );
                if( dailymotion_match )
                    return '<iframe src="//www.dailymotion.com/embed/video/' + dailymotion_match[1] + '" width="640" height="360" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>';

                // undefined -> create '<video/>' tag
            }
        })
        .change(function() {
            if( typeof console !== 'undefined' )
                ;//console.log( 'change' );
        })
        .focus(function() {
            if( typeof console !== 'undefined' )
                ;//console.log( 'focus' );
        })
        .blur(function() {
            if( typeof console !== 'undefined' )
                ;//console.log( 'blur' );
        });
    });

    // Demo-Buttons
    $('#editor3-readonly').click(function(e) {
        e.preventDefault();
        var isReadOnly = $('#editor3').wysiwyg('shell').readOnly();
        $('#editor3').wysiwyg('shell').readOnly( ! isReadOnly );
    });
    $('#editor3-bold').click(function(e) {
        e.preventDefault();
        $('#editor3').wysiwyg('shell').bold();
    });
    $('#editor3-red').click(function(e) {
        e.preventDefault();
        $('#editor3').wysiwyg('shell').highlight('#ff0000');
    });
    $('#editor3-sethtml').click(function(e) {
        e.preventDefault();
        $('#editor3').wysiwyg('shell').setHTML('This is the new text.');
    });
    $('#editor3-inserthtml').click(function(e) {
        e.preventDefault();
        $('#editor3').wysiwyg('shell').insertHTML('Insert some text.');
    });
    $('#editor3-reset').click(function(e) {
        e.preventDefault();
        $('#editor3').closest('form').trigger('reset');
    });

    // Raw editor
    var option = {
        element: 'editor0', // or: document.getElementById('editor0')
        onKeyPress: function( key, character, shiftKey, altKey, ctrlKey, metaKey ) {
                        if( typeof console !== 'undefined' )
                            console.log( 'RAW: '+character+' key pressed' );
                    },
        onSelection: function( collapsed, rect, nodes, rightclick ) {
                        if( typeof console !== 'undefined' && rect )
                            console.log( 'RAW: selection rect('+rect.left+','+rect.top+','+rect.width+','+rect.height+'), '+nodes.length+' nodes' );
                    },
        onPlaceholder: function( visible ) {
                        if( typeof console !== 'undefined' )
                            console.log( 'RAW: placeholder ' + (visible ? 'visible' : 'hidden') );
                    }
    };
    var wysiwygeditor = wysiwyg( option );
    //wysiwygeditor.setHTML( '<html>' );
});
</script>
<style>
body {
    font-family: Arial,Verdana;
}
p {
    margin: 0;
    padding: 0;
}
.button {
    -moz-user-select: none;
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    -khtml-user-select: none;
    -ms-user-select: none;
    -user-select: none;
}
/* CSS for the font-name + font-size plugin */
.wysiwyg-plugin-list {
    max-height: 16em;
    overflow: auto;
    overflow-x: hidden;
    overflow-y: scroll;
}
.wysiwyg-plugin-list a,
.wysiwyg-plugin-list a:link,
.wysiwyg-plugin-list a:visited {
    display: block;
    color: black;
    padding: 5px 10px;
    text-decoration: none;
    cursor: pointer;
}
.wysiwyg-plugin-list a:hover {
    color: HighlightText;
    background-color: Highlight;
}
/* CSS for the smiley plugin */
.wysiwyg-plugin-smilies {
    padding: 10px;
    text-align: center;
    white-space: normal;
}
.wysiwyg-plugin-smilies img {
    display: -moz-inline-stack; /* inline-block: http://blog.mozilla.org/webdev/2009/02/20/cross-browser-inline-block/ */
    display: inline-block;
    *display: inline;
}
/* Fake bootstrap + uikit */
.fake-bootstrap.wysiwyg-container.wysiwyg-active {
    /* colors shamelessly stolen from bootstrap.form-control:focus */
    border-color: #66afe9;
    box-shadow: 0 1px 1px rgba(0, 0, 0, 0.075) inset, 0 0 8px rgba(102, 175, 233, 0.6)
}
.fake-uikit.wysiwyg-container.wysiwyg-active {
    border-color: #99baca !important;
    background: #f5fbfe !important;
}
</style>
</head>
<body>

<a href="https://github.com/wysiwygjs/wysiwyg.js"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://camo.githubusercontent.com/365986a132ccd6a44c23a9169022c0b5c890c387/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f7265645f6161303030302e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_red_aa0000.png"></a>

<h1><center>wysiwyg.js</center></h1>

<pre style="width:860px; margin: 30px auto;">
'wysiwyg.js' is a (uglified) 12k contenteditable-editor with no dependencies.
It does only:
    * Transforms any HTML-element into contenteditable
    * onSelection-event: e.g. to open a toolbar
    * onKeyDown/Press/Up-events: e.g. to handle hotkeys
    * onPlaceholder-event: show/hide a placeholder
    * handle popups
    * .bold(), .forecolor(), .inserthtml(), ... functions

It works with:
    * Internet Explorer 6+
    * Firefox 3.5+
    * Chrome 4+
    * Safari 3.1+

If a &lt;textarea&gt; was used as 'element', the library:
    * keeps the &lt;textarea&gt; in sync
    * falls back to the &lt;textarea&gt; if the browser does not support 'contenteditable'
    * Old iOS and Android 2.3- also degrade to &lt;textarea&gt;

There is also a (uglified) 10k jQuery-plugin '$.wysiwyg()' - plus (minified) 2k CSS -
to create a featured editor which depends on:
    * wysiwyg.js
    * jQuery
    * FontAwesome (or JPG/PNG/GIF/SVG images)
The toolbar is easy to extend - e.g. smiley, fontname and fontsize buttons below.
To enable autocomplete set an onAutcomplete() callback (try '@' in the examples).
It is used on a website with 300M page impressions a month.
</pre>

<h1><center>Examples:</center></h1>

<div style="width:860px; margin: 30px auto;">
  <div style="color:#aa0000;font-weight:bold">$.wysiwyg(): Toolbar on top and on selection, smiley+fontname plugin:</div>
  <textarea id="editor1" name="editor" placeholder="Type your text here...">
    Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.
    Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
    Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  </textarea>
</div>

<div style="width:860px; margin: 30px auto;">
  <div style="color:#aa0000;font-weight:bold">$.wysiwyg(): Toolbar - if active - on bottom, custom buttons and smiley+header+fontsize plugin:</div>
  <!-- flickr-free markup -->
  <div class="wysiwyg-container fake-uikit">
   <div class="wysiwyg-wrapper">
    <div class="wysiwyg-placeholder">Initialized via flickr-free markup</div>
    <div class="wysiwyg-editor" contenteditable="true"></div>
    <textarea id="editor2" style="display:none;" name="editor"></textarea>
   </div>
  </div>  
</div>

<div style="width:860px; margin: 30px auto;">
  <div style="color:#aa0000;font-weight:bold">$.wysiwyg(): Readonly, toolbar on selection, hijack right-click, smiley plugin:</div>
  <form method="POST" action="/">
   <textarea id="editor3" name="editor" readonly="readonly" placeholder="Type your text here...">
    Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.
    Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
    Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
   </textarea>
  </form> 
  <a id="editor3-readonly" class="button" href="#" unselectable="on">toggle readonly</a> |
  <a id="editor3-bold" class="button" href="#" unselectable="on">bold</a> |
  <a id="editor3-red" class="button" href="#" unselectable="on">red background</a> |
  <a id="editor3-sethtml" class="button" href="#" unselectable="on">set html</a> |
  <a id="editor3-inserthtml" class="button" href="#" unselectable="on">insert html</a>
  <a id="editor3-reset" class="button" href="#" unselectable="on">reset form</a>
</div>

<div style="width:860px; margin: 30px auto;">
  <div style="color:#aa0000;font-weight:bold">Raw wysiwyg.js-editor (no jQuery, no CSS):</div>
  <div id="editor0" style="padding:5px;border:1px dashed black">
    Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.
    Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
    Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  </div>
</div>

<h1><center>$.wysiwyg() API:</center></h1>

<pre style="width:860px; margin: 30px auto;">
// create editor:
$(element).wysiwyg({
    class: 'some-more-classes',
    toolbar: 'selection'|'top'|'top-focus'|'top-selection'|'top-focus-selection'|'bottom'|'bottom-focus'|'bottom-selection'|'bottom-focus-selection',
    buttons: {
        buttonname: {
            title: 'tooltip text',
            // How should the button look like?
            image: '\u1234' | '&lt;img src="path/to/image.jpg"&gt;',
            html: '&lt;raw html&gt;',
            // What should the button do?
            popup: function( $popup, $button ) { ... },
            click: function( $button ) { ... },
            // Where should the button be placed?
            showstatic: true, // on the static toolbar
            showselection: true // on selection toolbar
            // anything else passed as "prop()" ...
        },
        // build-in:
        insertimage: { ... },
        insertvideo: { ... },
        insertlink: { ... },
        bold: { ... },
        italic: { ... },
        underline: { ... },
        strikethrough: { ... },
        forecolor: { ... },
        highlight: { ... },
        alignleft: { ... },
        aligncenter: { ... },
        alignright: { ... },
        alignjustify: { ... },
        subscript: { ... },
        superscript: { ... },
        indent: { ... },
        outdent: { ... },
        orderedList: { ... },
        unorderedList: { ... },
        removeformat: { ... }
    },
    submit: { ... },
    selectImage: 'Click or drop image',
    placeholderUrl: 'www.example.com',
    placeholderEmbed: '&lt;embed/&gt;',
    maxImageSize: [600,200],
    filterImageType: function( file ) { ... },
    onKeyDown: function( key, character, shiftKey, altKey, ctrlKey, metaKey ) { ... },
    onKeyPress: function( key, character, shiftKey, altKey, ctrlKey, metaKey ) { ... },
    onKeyUp: function( key, character, shiftKey, altKey, ctrlKey, metaKey ) { ... },
    onAutocomplete: function( tyed, key, character, shiftKey, altKey, ctrlKey, metaKey ) { ... },
    onImageUpload: function( insert_image ) { ... },
    forceImageUpload: false,
    videoFromUrl: function( url ) { ... }
});

// surrounding div:
$(element).wysiwyg('container');

// accessing 'wysiwyg.js':
$(element).wysiwyg('shell').bold();
$(element).wysiwyg('shell').forecolor( '#ff0000' );
$(element).wysiwyg('shell').insertHTML( '&lt;b&gt;some text&lt;/b&gt;' );
</pre>

<h1><center>Raw wysiwyg.js API:</center></h1>

<pre style="width:860px; margin: 30px auto;">
// create wysiwyg:
var wysiwygeditor = wysiwyg({
    element: 'editor-id' || document.getElementById('editor-id'),
    onKeyDown: function( key, character, shiftKey, altKey, ctrlKey, metaKey ) {
        },
    onKeyPress: function( key, character, shiftKey, altKey, ctrlKey, metaKey ) {
        },
    onKeyUp: function( key, character, shiftKey, altKey, ctrlKey, metaKey ) {
        },
    onSelection: function( collapsed, rect, nodes, rightclick ) {
        },
    onPlaceholder: function( visible ) {
        },
    onOpenpopup: function() {
        },
    onClosepopup: function() {
        },
    hijackContextmenu: false
});

// properties:
wysiwygeditor.getElement();
wysiwygeditor.getHTML(); -> 'html'
wysiwygeditor.setHTML( html );
wysiwygeditor.getSelectedHTML(); -> 'html'|false
wysiwygeditor.sync();
wysiwygeditor.readOnly(); // -> query
wysiwygeditor.readOnly( true|false );

// selection and popup:
wysiwygeditor.collapseSelection();
wysiwygeditor.expandSelection( preceding, following );
wysiwygeditor.openPopup(); -> popup-handle
wysiwygeditor.closePopup();

// exec commands:
wysiwygeditor.removeFormat();
wysiwygeditor.bold();
wysiwygeditor.italic();
wysiwygeditor.underline();
wysiwygeditor.strikethrough();
wysiwygeditor.forecolor( color );
wysiwygeditor.highlight( color );
wysiwygeditor.fontName( fontname );
wysiwygeditor.fontSize( fontsize );
wysiwygeditor.subscript();
wysiwygeditor.superscript();
wysiwygeditor.align( 'left'|'center'|'right'|'justify' );
wysiwygeditor.format( tagname );
wysiwygeditor.indent( outdent );
wysiwygeditor.insertLink( url );
wysiwygeditor.insertImage( url );
wysiwygeditor.insertHTML( html );
wysiwygeditor.insertList( ordered );
</pre>

</body>
</html>