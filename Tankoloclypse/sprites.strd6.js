var Tile = function(image, baseX, baseY, cellWidth, cellHeight) {
  var self = {
    update: function() {},

    draw: function(canvas, x, y, options) {
      canvas.drawImage(image,
        baseX,
        baseY,
        cellWidth,
        cellHeight,
        x,
        y,
        cellWidth,
        cellHeight,
        options
      );
    }
  };

  return self;
};

var Composite = function(tileData) {
  var tileCount = tileData.length;

  var self = {
    update: function() {},

    draw: function(canvas, x, y, options) {
      var datum;

      for(var i = 0; i < tileCount; i++) {
        datum = tileData[i];
        datum.tile.draw(canvas, x + datum.x, y + datum.y, options);
      }
    }
  };

  return self;
};

var Animation = function(frameData) {
  var currentFrame = 0;
  var frameCount = frameData.length;

  return {
    update: function() {
      currentFrame = (currentFrame + 1) % frameCount;
    },

    draw: function(canvas, x, y, options) {
      frameData[currentFrame].draw(canvas, x, y, options);
    }
  };
};
