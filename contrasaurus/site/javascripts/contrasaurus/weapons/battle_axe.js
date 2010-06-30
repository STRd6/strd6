function BattleAxe(I) {
  I = I || {};

  $.reverseMerge(I, {
    exitPoints: [Point(10, -30)],
    radius: 5,
    sprite: Sprite.load("images/weapons/battleAxe.png"),
    theta: 0
  });

  var self = Weapon(I).extend({
    getTransform: function() {
      return Matrix.rotation(I.theta, Point(60, 0)).concat(Matrix.translation(70, -50));
    },

    generateProjectile: function(direction, position) {
      //TODO: Throw Axe
      return Bullet(direction, {
        duration: 1,
        speed: 0,
        sprite: Sprite.EMPTY,
        radius: 20,
        x: position.x,
        y: position.y
      });
    },

    after: {
      update: function() {
        I.theta = Math.sin(I.age / 4) * (Math.PI / 2) + Math.PI / 4;
      }
    }
  });

  return self;
}
