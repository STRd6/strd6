function Bazooka(I) {
  I = I || {};

  $.reverseMerge(I, {
    attachment: "back",
    power: 10,
    sprite: Sprite.load("images/weapons/missile_launcher.png")
  });

  var self = Weapon(I).extend({
    generateProjectile: function(direction, position) {
      return HomingMissile(position);
    }
  });
  return self;
}