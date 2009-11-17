(function($){
  $.fn.powerCanvas = function(options) {
    return this.each(function() {
      var canvas = this;
      var context;
      
      var colorStack = [];
      
      function pushStyle(color) {
        colorStack.push(context.fillStyle);
        context.fillStyle = color;
      }

      function popStyle() {
        context.fillStyle = colorStack.pop();
      }

      var $canvas = $(canvas).extend({
        drawLine: function(x1, y1, x2, y2) {
          context.lineWidth = 3;
          context.beginPath();
          context.moveTo(x1, y1);
          context.lineTo(x2, y2);
          context.closePath();
          context.stroke();
        },
        
        drawImage: function(image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight) {
          context.drawImage(image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight);
        },

        fill: function(color) {
          pushStyle(color);
          context.fillRect(0, 0, canvas.width, canvas.height);
          popStyle();

          return this;
        },

        fillCircle: function(x, y, radius, color) {
          context.fillStyle = color;
          context.beginPath();
          context.arc(x, y, radius, 0, Math.PI*2, true);
          context.closePath();
          context.fill();
          
          return this;
        },

        fillRect: function(x, y, width, height) {
          context.fillRect(x, y, width, height);

          return this;
        },

        fillText: function(text, x, y) {
          context.fillText(text, x, y);

          return this;
        },

        fillColor: function(color) {
          if(color) {
            context.fillStyle = color;
            return this;
          } else {
            return context.fillStyle;
          }
        },

        strokeColor: function(color) {
          if(color) {
            context.strokeStyle = color;
            return this;
          } else {
            return context.strokeStyle;
          }
        },

        height: function() {
          return canvas.height;
        },

        width: function() {
          return canvas.width;
        }
      });

      if(canvas.getContext) {
        context = canvas.getContext('2d');

        if(options.init) {
          options.init($canvas);
        }
      }
    });
  };
})(jQuery);
