function ThrownItem(I) {
  I = I || {};

   $.reverseMerge(I, {
     speed: 20,
     theta: -Math.PI/6,
     weaponName: "battleAxe"
   });

  $.reverseMerge(I, {
    collideDamage: 5,
    collisionType: "dinoBullet",
    dispersion: 0,
    duration: -1,
    effectCount: 1,
    radius: 30,
    rotation: 0,
    rotationalVelocity: Math.PI/10,
    sprite: Sprite.load("images/weapons/" + I.weaponName + ".png"),
    xVelocity: Math.cos(I.theta)*I.speed,
    yVelocity: Math.sin(I.theta)*I.speed + 1,
    x: dino.position().x,
    y: dino.position().y
  });

  function detonate() {
    if(I.active) {
      I.active = false;
      addGameObject(Explosion({
        collideDamage: 20,
        collisionType: "dinoBullet",
        x: I.x + 20,
        y: I.y - 50
      }));
    }
  }

  var self = Bullet(I).extend({
    getTransform: GameObject.rotationGetTransform(I),
    
    land: function() {
      I.active = false;
    },
    before: {
      hit: function(other) {
        detonate();
      }
    },
    after: {
      hit: function(other) {
        if(other.bulletHitEffect) {
          other.bulletHitEffect(self);
        }
      },
      update: function() {
        GameObject.generateCheckBounds(I);
        I.rotation += I.rotationalVelocity;
        I.yVelocity += GRAVITY;
      }
    }
  });

  return self;
}
