function Flamethrower(I) {
  I = I || {};
  
  var mouthPoint = {
    x: 45,
    y: 20
  };

  $.reverseMerge(I, {
    age: 0,
    power: 0,
    radius: 5,
    theta: 0,
    x: 0,
    y: 0
  });

  var self = Weapon(I).extend({

    shoot: function(direction, midpoint, transform) {

      if (rand(100) < I.power) {
        var exitPoint = transformPoint(mouthPoint, transform);
        shoot(Flame(direction, {
          x: midpoint.x + exitPoint.x,
          y: midpoint.y + exitPoint.y
        }));
      }
    },

    update: $.noop
  });
  return self;
}