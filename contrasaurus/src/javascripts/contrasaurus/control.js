function Control(character, keyDown) {
  $.each({

    "w up": function() {
      keyDown.up = true;
    },

    "t": function() {
      keyDown.t = true;
    },

    "left a": function() {
      keyDown.left = true;
    },

    "right d": function() {
      keyDown.right = true;
    },

    "down s": function() {
      keyDown.down = true;
    },

    "space": function() {
      keyDown.space = true;
    }
  }, function(key, fn) {
    $(document).bind('keydown', key, function() {
      fn();
      return false;
    });
  });

  // Prevent default scrolling behavior
  $('body').bind('touchmove', function(e){
    e.preventDefault();
    event.preventDefault();
  });

  $('body').bind('touchstart', function(e){
    e.preventDefault();
    event.preventDefault();

    return false;
  });

  $('.touch').bind('touchstart', handleTouch);

  $('.touch').bind('tap', function(e, info) {
    keyDown.space = true;

    return false;
  });

  $('#button').bind('touchstart', function(e){
    keyDown.space = true;

    character.bite();

    character.transition(character.states().bite);

    return false;
  });

  $('#control').bind('touchstart', function(e) {
    var offset = $(this).offset();

    var localY = event.changedTouches[0].pageY - offset.top;
    var localX = event.changedTouches[0].pageX - offset.left;

    target = Point(localX, localY);

    if ((target.x > 0 && target.x < 80) && (target.y > 52.5 && target.y < 160)) {
      keyDown.left = true;
      keyDown.right = false;

      e.preventDefault();
    }

    if ((target.x > 0 && target.x < 52.5) && (target.y > 0 && target.y < 52.5)) {
      keyDown.left = true;
      keyDown.up = true;
      keyDown.right = false;

      e.preventDefault();
    }

    if ((target.x >= 80 && target.x <= 160) && (target.y > 52.5 && target.y < 160)) {
      keyDown.right = true;
      keyDown.left = false;

      e.preventDefault();
    }

    //up-right
    if ((target.x >= 107.5 && target.x < 160) && (target.y > 0 && target.y < 52.5)) {
      keyDown.right = true;
      keyDown.up = true;
      keyDown.left = false;

      e.preventDefault();
    }

    //up
    if ((target.x >= 52.5 && target.x < 107.5) && (target.y > 0 && target.y < 52.5)) {
      keyDown.up = true;

      e.preventDefault();
    }
  });

  $('.touch').bind('touchend', function(e) {
    keyDown.up = false;
    keyDown.left = false;
    keyDown.right = false;
    keyDown.space = false;
  });

  $(document).bind('keyup', 'w up', function() {
    keyDown.up = false;
  });

  $(document).bind('keyup', 'left a', function() {
    keyDown.left = false;
  });

  $(document).bind('keyup', 'right d', function() {
    keyDown.right = false;
  });

  $(document).bind('keyup', 'down s', function() {
    keyDown.down = false;
  })

  $(document).bind('keyup', 'space', function() {
    keyDown.space = false;
  })

  $("#game_container").mousedown(function(event) {
     if(event.button == 0) {
       shooting = true;
     } else {
       secondaryShooting = true;
     }

     return false;
   }).mouseup(function(event) {
     if(event.button == 0) {
       shooting = false;
     } else {
       secondaryShooting = false;
     }
   });

  return {
    update: function() {
      if(keyDown.left) {
        if (!character.airborne() && (character.currentState() !== character.states().bite)) {
          character.xVelocity(-WALK_VELOCITY);
          character.transition(character.states().walk);
        } else if (!character.states().flyBite) {
          character.transition(character.state().fly);
        }
      } else {
        if(!character.airborne()) {
          character.xVelocity(0);
          character.transition(character.states().idle1);
        }
      }

      if(keyDown.right) {
        if (!character.airborne() && (character.currentState() !== character.states().bite)) {
          character.xVelocity(WALK_VELOCITY);
          character.transition(character.states().walk);
        } else if (!character.states().flyBite) {
          character.transition(character.state().fly);
        }
      } else {
        if(!character.airborne()) {
          character.xVelocity(0);
          character.transition(character.states().idle1);
        }
      }

      if(keyDown.up) {
        if (character.hasJetpack() && (character.currentState() !== character.states().bite)) {
          character.transition(character.states().fly);
        }
      }

      if(keyDown.space) {
        character.bite();
        character.transition(character.states().bite);
        keyDown.space = false;
      }

      if(keyDown.t) {
        character.toss();
      }
    }
  }
}