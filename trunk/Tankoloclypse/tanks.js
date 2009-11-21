
var RADIANS_PER_DEGREE = (2*Math.PI)/360;

var running = true;
var gravity = 0.98;

var ground = (function() {
  var heights = midpointDisplacement(8);

  return {
    heightAt: function(x) {
      return 125 - x/2;
    }
  };
})();

var Tank = function(x, y, color) {
  var width = 10;
  var height = 10;

  var barrelSize = 10;
  var angle = -135;
  var power = 10;

  var barrelPosition = function () {
    return {x: x + Math.cos(angle*RADIANS_PER_DEGREE)*barrelSize, y: y + Math.sin(angle*RADIANS_PER_DEGREE)*barrelSize}
  };

  var centerPoint = function() {
    return {x: x + width/2, y: y + height/2};
  }

  var self = {
    update: function() {

    },

    draw: function(canvas) {
      canvas.fillColor(color);
      canvas.fillRect(x, y, width, height);

      var barrelPos = barrelPosition();
      canvas.strokeColor(color);
      canvas.drawLine(x, y, barrelPos.x, barrelPos.y);

      canvas.fillColor("#FFF").fillText("P: " + power + "; D: " + angle, x, y - 10);
    },

    boundingBox: function() {
      return {x: x, y: y, w: width, h: height};
    },

    adjustAngle: function(byDegrees) {
      angle += byDegrees;
    },

    adjustPower: function(byAmount) {
      power += byAmount;
    },

    centerPoint: centerPoint,

    explode: function() {
      var point = centerPoint();
      explosions.push(Explosion(point.x, point.y));
    },

    fire: function() {
      var barrelPos = barrelPosition();
      bullets.push(
        Bullet(
          barrelPos.x,
          barrelPos.y,
          Math.cos(angle*RADIANS_PER_DEGREE)*power,
          Math.sin(angle*RADIANS_PER_DEGREE)*power
        )
      );
    },

    barrelPosition: barrelPosition,

    x: function() {return x;},
    y: function() {return y;},
    w: function() {return width;},
    h: function() {return height;}
  };

  return self;
};

var Bullet = function(x, y, vx, vy) {
  var active = true;
  var width = 2;
  var height = 2;

  var self = {
    active: function() {
      return active;
    },

    update: function() {
      x += vx;
      y += vy;

      vy += gravity;
    },

    draw: function() {
      canvas.fillColor("#EEE");
      canvas.fillRect(x, y, width, height);
    },

    explodeOn: function(tank) {
      tank.explode();
      active = false;
    },

    boundingBox: function() {
      return {x: x, y: y, w: width, h: height};
    },

    x: function() {return x;},
    y: function() {return y;},
    w: function() {return width;},
    h: function() {return height;}
  };

  return self;
};

var Explosion = function(x, y) {
  var maxRadius = 25;
  var radius = 0;
  var phase = 0;

  return {
    update: function() {
      switch(phase) {
        case 0:
          if(radius < maxRadius/2) {
            radius += 1;
          } else {
            phase = 1;
          }
          break;
        case 1:
          if(radius > 0) {
            radius -= 2;
          } else {
            phase = 2
          }
          break;
        case 2:
          if(radius < maxRadius) {
            radius += 2;
          } else {
            radius = 0;
            phase = 3;
          }
          break;
      }
    },

    active: function() {
      return phase < 3;
    },

    draw: function() {
      canvas.fillCircle(x, y, radius, "#F00");
    }
  };
};

var tanks = [];
var currentPlayer = 0;

var bullets = [];
var explosions = [];

$(function() {

  $('canvas').powerCanvas({init: function(_canvas) {
    canvas = _canvas;
    var p1 = rand(250);
    var p2 = rand(250);
    tanks[0] = Tank(p1, canvas.height() - ground.heightAt(p1) - 10, "#F0F");
    tanks[1] = Tank(p2, canvas.height() - ground.heightAt(p2) - 10, "#FF0");

    console.log(canvas.height() - ground.heightAt(0));

    var canvasWidth = canvas.width();
    var canvasHeight = canvas.height();

    function draw() {
      canvas.fill("#0F0").fillColor("#000");

      for(var i = 0; i < canvasWidth; i++)
        canvas.fillRect(i, 0, 1, canvasHeight - ground.heightAt(i));
      ;
    };

    function collision(bullet, tank) {
      var b = bullet.boundingBox();
      var t = tank.boundingBox();

      var xOverlap = (b.x < t.x && b.x + b.w >= t.x) ||
        (t.x < b.x && t.x + t.w >= b.x);
      var yOverlap = (b.y < t.y && b.y + b.h >= t.y) ||
        (t.y < b.y && t.y + t.h >= b.y);

      if(xOverlap && yOverlap) {
        bullet.explodeOn(tank);
      }
    }

    setInterval(function() {
      draw();

      $.each(bullets, function(index, bullet) {
        bullet.update();
        bullet.draw(canvas);

        $.each(tanks, function() {
          collision(bullet, this);
        });
      });

      bullets = bullets.select(function(bullet) {
        return bullet.active() && bullet.y() < canvasHeight;
      });

      $.each(tanks, function(index, tank) {
        tank.draw(canvas);
      });

      $.each(explosions, function() {
        this.update();
        this.draw(canvas);
      });

      explosions = explosions.select(function(explosion) {
        return explosion.active();
      });

      canvas.fillColor("#FFF")
        .fillText("Bullets: " + bullets.length, 0, 10)
        .fillText("Explosions: " + explosions.length, 0, 20)
      ;
    }, 100);
  }});
});
