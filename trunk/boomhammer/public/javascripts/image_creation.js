(function($){
  $(function() {
    $('#pixie').pixie({
      width: 32,
      height: 32,
      initializer: function(canvas) {
        canvas.addAction({
          name: "Save to Game",
          perform: function(canvas) {
            $.post('/creation/images', {
              'format': 'js',
              'image[file]': canvas.toBase64(),
              'authenticity_token': $token
            }, function(data){
              eval(data);
            },"script");
          }
        });

        canvas.addAction({
          name: "Load from Game",
          perform: function(canvas) {
            $('#image_load').show();
          }
        });

        loadJSON = function(data) {
          canvas.eachPixel(function(pixel, x, y) {
            var pos = x + y*canvas.width;
            pixel.color(data[pos]);
          });
        };
      }
    });
  });
})(jQuery);
