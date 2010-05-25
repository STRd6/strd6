function Dinosaur() {
  var width = 128;
  var height = 128;
  var jetpackCounter = 0;

  var x = (canvas.width() - width) / 2;
  var y = 0;

  var airborne = true;
  var berserk = false;

  var theta = 0;
  var thetaVelocity = Math.PI / 24;

  var jetpackInactiveTile = loadImageTile("images/jetpack.png");
  var jetpackActiveTile = loadImageTile("images/jetpack_active.png");
 
  var gunWidth = 0;
  var gunTile = loadImageTile("images/machine_gun.png", function(tile) {
    gunWidth = tile.width;
  });
  var gunDelta = {x: 25, y: 4};

  var I = {
    x: x,
    y: y,
    width: width,
    height: height,
    color: "#00F",
    health: 500,
    weapons: {
      bombs: 0,
      machineGun: 1,
      shotgun: 6,
      bazooka: 4
    },
    xVelocity: 1,
    yVelocity: 6,
    collideDamage: 2
  };

  var healthMax = I.health;

  function fireWeapons() {
    var berserkTheta = theta - Math.PI / 24;

    // Machine Gun Fire
    shoot(Bullet(theta, {
      x: self.midpoint().x + gunDelta.x + Math.cos(theta) * gunWidth/2,
      y: self.midpoint().y + gunDelta.y + Math.sin(theta) * gunWidth/2
    }));

    if (berserk) {
      shoot(Bullet(berserkTheta, {
        x: self.midpoint().x + gunDelta.x + Math.cos(berserkTheta) * gunWidth/2,
        y: self.midpoint().y + gunDelta.y + Math.sin(berserkTheta) * gunWidth/2
      }));
    }

    // Mortars
    if (rand(20) == 0) {
      shoot(Mortar({
        x: self.midpoint().x,
        y: self.midpoint().y
      }));
    }

    if (I.weapons.bombs && rand(100) < I.weapons.bombs) {
      // Bomb Blast
      (24).times(function(i) {
        var theta = (i / 12) * Math.PI;
        shoot(Bullet(theta, {
          x: self.midpoint().x,
          y: self.midpoint().y
        }));
      }
    )};

    if (I.weapons.bazooka && rand(100) < I.weapons.bazooka) {
      //Bazooka shot
      shoot(Missile(theta, {
        x: self.midpoint().x,
        y: self.midpoint().y
      }));
    }

    if(I.weapons.shotgun && rand(100) < I.weapons.shotgun) {
      var target = nearestEnemy();
      // Shotgun Blast
      var direction;

      if(target) {
        var targetMidpoint = target.midpoint();
        var targetDistance = distance(self.midpoint(), targetMidpoint);
        var targetVelocity = target.velocity();

        targetMidpoint.y += (targetDistance / 10) * targetVelocity.y;
        targetMidpoint.x += (targetDistance / 10) * targetVelocity.x;

        direction = Math.atan2(
          targetMidpoint.y - self.midpoint().y,
          targetMidpoint.x - self.midpoint().x
        );
      } else {
        direction = Math.atan2(I.yVelocity, I.xVelocity);
      }

      (3 + rand(I.weapons.shotgun)).times(function() {
        function fuzz() {
          return Math.random() * 20 - 10;
        }

        var x = I.x + I.width/2 + fuzz();
        var y = I.y + I.height/2 + fuzz() * 2;

        shoot(Bullet(direction, { x: x, y: y }));
      });
    }
  }

  function heal(amount) {
    I.health = Math.clamp(I.health + amount, 0, healthMax);
  }

  function nearestEnemy() {
    var nearest;
    var nearestDistance;

    $.each(currentLevel.enemies(), function(i, enemy) {
      var enemyDistance = distance(self.midpoint(), enemy.midpoint());
      if(nearest) {
        if(nearestDistance > enemyDistance) {
          nearest = enemy;
          nearestDistance = enemyDistance;
        }
      } else {
        nearest = enemy;
        nearestDistance = enemyDistance
      }
    });

    return nearest;
  }

  // Adjust machine gun angle
  function updateGunAngle() {
    theta += thetaVelocity;

    // Change gun rotation direction
    if(Math.random() < 0.05) {
      thetaVelocity = thetaVelocity * -1;
    }

    // Flip target angle 180
    if(Math.random() < 0.05) {
      theta += Math.PI;
    }

    // Don't shoot machine gun into the ground
    if(Math.sin(-theta) < -0.3 && !airborne) {
      theta -= thetaVelocity * 2;
    }
  }

  var self = GameObject(I).extend({
    bump: function() {
      I.xVelocity = -I.xVelocity;
    },

    draw: function(canvas) {
      dinoTile.draw(canvas, I.x, I.y);

      var midpoint = self.midpoint();

      // Draw Jetpack
      if (jetpackCounter > 0) {
        jetpackActiveTile.draw(canvas,
          I.x,
          I.y + 35
        );
      } else {
      jetpackInactiveTile.draw(canvas,
          I.x,
          I.y + 35
        );
      }

      // Draw Machine Gun
      gunTile.draw(canvas, 
        midpoint.x + gunDelta.x - gunTile.registrationPoint.x,
        midpoint.y + gunDelta.y - gunTile.registrationPoint.y,
        {
          rotation: theta
        }
      );
    },
    land: function(h) {
      I.y = h - (I.height + 1);
      I.yVelocity = 0;
      I.xVelocity = (Math.abs(I.xVelocity) / I.xVelocity) * 5;
      airborne = false;
    },
    powerup: function(powerup) {
      if(powerup.health) {
        display("FOOD!");
        heal(powerup.health);
      }

      if(powerup.weapon) {
        for(var weapon in powerup.weapon) {
          display(weapon + "!");
          I.weapons[weapon] += powerup.weapon[weapon];
        }
      }
    },
    after: {
      update: function() {
        if(I.health < healthMax / 2) {
          berserk = true;
        } else {
          berserk = false;
        }

        // Flip when hitting edges of screen
        if (I.x + I.width > canvas.width() || I.x < 0) {
          I.xVelocity = I.xVelocity * -1;
          I.x += I.xVelocity;
        }

        // Wiggle in the air
        if (airborne) {
          I.xVelocity += (Math.random() - 0.5) * 3;
          I.xVelocity = I.xVelocity * 0.9;
        }

        fireWeapons();
        updateGunAngle();

        if(Math.random() < 0.01 && jetpackCounter <= 0) {
          jetpackCounter += 50;
        }

        if (jetpackCounter > 0 && !airborne) {
          I.yVelocity = -1;
          airborne = true;
        }

        if (jetpackCounter <= 0 && airborne) {
          I.yVelocity = 6;
        }

        if (jetpackCounter > 0) {
          jetpackCounter--;
        }
      }
    }
  });

  return self;
}