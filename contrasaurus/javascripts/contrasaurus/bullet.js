function Bullet(theta, I) {
  var speed = 10;
  var yMax = canvas.height() - Floor.LEVEL;
  var xMax = canvas.width();

  $.reverseMerge(I, {
    collideDamage: 1,
    width: 4,
    height: 4,
    color: "#000",
    xVelocity: Math.cos(theta)*speed,
    yVelocity: Math.sin(theta)*speed
  });

  var self = GameObject(I).extend({
    draw: function(canvas) {
      if (I.sprite) {
        I.sprite.draw(canvas, I.x, I.y);
      } else {
        var midpoint = self.midpoint();
        canvas.fillCircle(midpoint.x, midpoint.y, I.width/2, I.color);
      }
    },
    after: {
      update: function() {
        // Check Bounds
        if (I.x >= 0 && I.x < xMax &&
          I.y >= 0 && I.y < yMax) {
          I.active = I.active && true;
        } else {
          I.active = false;
        }
        return I.active;
      }
    }
  });

  return self;
}