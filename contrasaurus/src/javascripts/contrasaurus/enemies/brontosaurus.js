function Brontosaurus(I) {
  I = I || {};

  $.reverseMerge(I, {
    health: 500,
    nutrition: 0,
    pointsWorth: 50000,
    radius: 90,
    xVelocity: 0,
    y: CANVAS_HEIGHT - Floor.LEVEL
  });

  var states = {
    angry: State({
      complete: function() {
        I.currentState = states.attack;
      },
      duration: 18,
      model: Model.loadJSONUrl("data/brontosaurus/angry.model.json"),
      update: function() {
        I.xVelocity = 0;
      }
    }),
    attack: State({
      complete: function() {
        I.currentState = states.stand;
      },
      duration: 48,
      model: Model.loadJSONUrl("data/brontosaurus/attack.model.json"),
      update: function() {
        I.xVelocity = 0;
      }
    }),
    stand: State({
      complete: function() {
        I.currentState = states.angry;
      },
      duration: 12,
      model: Model.loadJSONUrl("data/brontosaurus/stand.model.json"),
      update: function() {
        I.xVelocity = 0;
      }
    }),
    walk: State({
      complete: function() {
        I.currentState = states.stand;
      },
      duration: 54,
      model: Model.loadJSONUrl("data/brontosaurus/walk.model.json"),
      update: function() {
        I.xVelocity = -1;
      }
    })
  };

  I.currentState = states.walk;

  var self = Boss(I).extend({
    bulletHitEffect: Enemy.bloodSprayEffect,

    getTransform: function() {
      return Matrix.translation(I.x, I.y);
    }
  });

  self.extend(Biteable(I));
  self.extend(Stateful(I));

  var sadSprite = Sprite.load("images/enemies/brontosaurus/pain.png");

  self.bind('destroy', function() {
    addGameObject(EffectGenerator($.extend(self.position(), {
      radius: 100
    })));

    addGameObject(Effect($.extend(self.position(), {
      duration: 100,
      rotation: 0,
      sprite: sadSprite,
      velocity: Point(0, 0)
    })));
  });

  return self;
}
