(function($){
  $.fn.powerCanvas = function(options) {
    options = options || {};

      var canvas = this.get(0);
      var context;

      function withState(x, y, options, block) {
        context.save();

        context.translate(x, y);

        if(options) {
          if(options.hFlip) {
            context.transform(-1, 0, 0, 1, 0, 0);
          }

          if(options.vFlip) {
            context.transform(1, 0, 0, -1, 0, 0);
          }

          if(options.rotation) {
            var theta = options.rotation;
            context.transform(
              Math.cos(theta), Math.sin(-theta),
              Math.sin(theta), Math.cos(theta),
              0, 0
            );
          }
        }

        block();

        context.restore();
      }

      var $canvas = $(canvas).extend({
        withState: withState,

        drawLine: function(x1, y1, x2, y2, width) {
          width = width || 3;

          context.lineWidth = width;
          context.beginPath();
          context.moveTo(x1, y1);
          context.lineTo(x2, y2);
          context.closePath();
          context.stroke();
        },

        drawImage: function(image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight, options) {
          withState(dx, dy, options, function() {
            context.drawImage(image, sx, sy, sWidth, sHeight, 0, 0, dWidth, dHeight);
          });

          return this;
        },

        transform: function(m11, m12, m21, m22, dx, dy) {
          context.transform(m11, m12, m21, m22, dx, dy);

          return this;
        },

        clear: function() {
          context.clearRect(0, 0, canvas.width, canvas.height);

          return this;
        },

        fill: function(color) {
          context.fillStyle = color;
          context.fillRect(0, 0, canvas.width, canvas.height);

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

        return $canvas;
      } else {
        return false;
      }

  };
})(jQuery);
