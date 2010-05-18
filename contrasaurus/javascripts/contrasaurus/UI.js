function ProgressBar(I) {
  function completeness() {
    return I.value / I.max;
  }
  
  // Init Defaults
  I = $.extend({
    backgroundColor: "#000",
    color: "#0C0",
    colorMap: function() {
      return I.color;
    },
    borderColor: "#FFF",
    borderWidth: 2,
    vertical: false
  }, I);
  
  var self = {
    draw: function(canvas) {
      canvas.fillColor(I.borderColor);
      canvas.fillRect(
        I.x - I.borderWidth, 
        I.y - I.borderWidth, 
        I.width + 2 * I.borderWidth, 
        I.height + 2 * I.borderWidth
      );
      
      canvas.fillColor(I.backgroundColor);
      canvas.fillRect(I.x, I.y, I.width, I.height);
      
      canvas.fillColor(I.colorMap(completeness()));
      if(I.vertical) {
        canvas.fillRect(I.x, I.y - (1 - I.height * completeness()), I.width, I.height * completeness());
      } else {
        canvas.fillRect(I.x, I.y, I.width * completeness(), I.height);
      }
    },

    value: function(newValue) {
      if(newValue != undefined) {
        I.value = Math.min(newValue, I.max);
        return self;
      } else {
        return I.value;
      }
    }
  };
  
  return self;
}

function GameText(text, I) {
  I.y -= 30;
  I.width = 1;
  I.height = 1;

  return GameObject(I).extend({
    draw: function(canvas) {
      canvas.fillColor("#000");
      canvas.fillText(text, I.x, I.y);
    },

    after: {
      update: function() {
        if(I.age > 30) {
          I.active = false;
        }
      }
    }
  });
}

function Scene(backgrounds, foregrounds) {
  function drawLayersGenerator(layers) {
    return function(position, canvas) {
      $.each(layers, function(i, layer) {
        var xPosition = layer.position.x + position.x;
        var yPosition = layer.position.y + position.y;

        if(layer.repeat) {
          xPosition = Math.mod(xPosition, canvas.width());
          yPosition = Math.mod(yPosition, canvas.height());

          layer.image.draw(canvas,
            xPosition,
            yPosition
          );

          // X-repeat
          layer.image.draw(canvas,
            xPosition - canvas.width(),
            yPosition
          );

          // Y-repeat
          layer.image.draw(canvas,
            xPosition,
            yPosition - canvas.height()
          );

          // XY-repeat
          layer.image.draw(canvas,
            xPosition - canvas.width(),
            yPosition - canvas.height()
          );
        } else {
          layer.image.draw(canvas,
            xPosition,
            yPosition
          );
        }

        // TODO: Move to update
        if(layer.rate) {
          layer.position.x += layer.rate.x;
        }
      });
    }
  }

  return {
    drawBackgrounds: drawLayersGenerator(backgrounds),

    drawForegrounds: function(position, canvas) {
      $.each(foregrounds, function(i, foreground) {
        var offset = canvas.width();

        if(foreground.position > 0) {
          offset = -offset;
        }

        foreground.image.draw(canvas, foreground.position, foreground.y);
        foreground.image.draw(canvas, foreground.position + offset, foreground.y);
        foreground.position = (foreground.position + foreground.rate) % canvas.width();
      });
    }
  }
}
