$( function( ) {
  var canvas = $( '<canvas width="4" height="5" />' );

  $( '#page_url' ).change( function( ) {
    $.ajax( '/pages/content', {
      data: {
        page: {
          url: $( '#page_url' ).val()
        }
      },
      success: function( result ) {
        $( '#page_content' ).val( result ).change();
      },
      error: function( xhr, textStatus ) {
        alert( textStatus );
      }
    } );
  } );

  $( '#page_content' ).change( function( ) {
    var singleLine = $( '#page_content' ).val().replace( /\s+/g, ' ' );
    $( '#page_cache_text' ).val( 'data:,' + window.encodeURIComponent( singleLine ) );
    $( '#page_cache_image' ).val( toImage( singleLine ) );
  } );

  function toImage( text ) {
    var characters = $( '#characters' );
    
    text = text.toLowerCase();

    var width = Math.ceil( Math.sqrt( text.length ) );
    var height = Math.ceil( text.length / width );

    canvas[ 0 ].width = width * 4;
    canvas[ 0 ].height = height * 5;

    var context = canvas[0].getContext( '2d' );
    context.imageSmoothingEnabled = false;
    context.mozImageSmoothingEnabled = false;
    context.msImageSmoothingEnabled = false;

    context.fillStyle = '#ffffff';
    context.fillRect( 0, 0, width * 4, height * 5 );

    var i = 0, code, row, col;

    for ( ; i < text.length; i++ ) {
      code = text.charCodeAt( i );

      if ( code >= 32 && code <= 127 ) {
        row = Math.floor( i / width );
        col = i % width;

        context.drawImage(characters[ 0 ], (code % 16) * 4, ( Math.floor( code / 16 ) - 2 ) * 5, 4, 5, col * 4, row * 5, 4, 5 );
      }
    }

    return canvas[0].toDataURL( 'image/png' );
    //$( '#output' ).prop( 'src', canvas[0].toDataURL( 'image/png' ) );
  }

  $( '.new_page, .edit_page' ).submit( function( ) {
  } );
} );
