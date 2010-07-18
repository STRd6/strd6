function Parasoldier(I) {
  I = I || {};

  var theta = Math.random() * (Math.PI * 2);

  $.reverseMerge(I, {
    health: 3,
    hitCircles: [{"x":-1,"y":36,"radius":13},{"x":-1,"y":10,"radius":14}],
    radius: 40,
    yVelocity: 4,
    color: "#F00",
    collideDamage: 1,
    pointsWorth: 1000,
    shootLogic: function() {
      if (Math.random() < 0.3) {
        self.shoot(
          theta, {
            x: self.midpoint().x,
            y: self.midpoint().y,
            sprite: Sprite.load("images/effects/enemybullet1_small.png")
          }
        );
      }
    },
    sprite: Sprite.load("images/enemies/parasoldier.png"),
    type: 'parasoldier',
    x: rand(CANVAS_WIDTH),
    y: 45
  });

  var self = Enemy(I).extend({
    land: function(h) {
      I.y = h - I.radius;
      I.yVelocity = 0;
    },

    after: {
      hit: function(other) {
        if(other.bump) {
          other.bump();
        }
      },
      update: function() {
        I.shootLogic();
      }
    }
  });

  I.hFlip = (I.x >= CANVAS_WIDTH / 2 ? true : false);

  if (I.hFlip && Math.cos(theta) > 0) {
    theta -= Math.PI;
  }

  if (!I.hFlip && Math.cos(theta) <= 0) {
    theta += Math.PI;
  }

  return self;
}