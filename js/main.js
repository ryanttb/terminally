$( function( ) {
  var outputCharWidth = 128;
  var canvas = $( '<canvas width="4" height="5" />' );

  var characters = $( '#characters' );
  
  $( '#convert' ).submit( function( ) {
    var text = $( '#text' ).val().toLowerCase();

    var width = outputCharWidth;
    var height = Math.ceil( text.length / outputCharWidth );

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

      row = Math.floor( i / outputCharWidth );
      col = i % outputCharWidth;

      context.drawImage(characters[ 0 ], (code % 16) * 4, ( Math.floor( code / 16 ) - 2 ) * 5, 4, 5, col * 4, row * 5, 4, 5 );
    }

    $( '#output' ).prop( 'src', canvas[0].toDataURL( 'image/png' ) );
    return false;
  } );
} );
