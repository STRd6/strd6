/*global Module, GameObject, jQuery, rand */

(function($) {
  /*global Cell */
  Cell = function(game) {
    var $self;
    var state = Cell.state.dirt;

    // Inherit from GameObject
    var self = $.extend(GameObject(game, 'cell'), {
      click: function() {
        self.setState(Cell.state.water);

        $.each(self.neighbors, function(i, object) {
          object.setState(Cell.state.water);
        });
      },

      state: function() {
        return state;
      },

      setState: function(newState) {
        state = newState;
        $self.trigger('changed');
      }
    });

    $self = $(self);

    Module.Container(self);

    game.addCell(self);
    return self;
  };

  Cell.state = {
    stone: 0,
    dirt: 1,
    water: 2
  };

  /*global Item */
  Item = function(game, container) {
    var self = $.extend(GameObject(game), {
      click: function(params) {
        var inventory = params.inventory;

        if(inventory) {
          inventory.add(self);
        }
      },

      image: function() {
        return 'items/redgem';
      }
    });

    Module.Containable(self, container);

    return self;
  };

  /*global Plant */
  Plant = function(game, startingCell) {
    var self;
    var $self;
    var age = rand(50);
    var state = Plant.state.seed;

    var setState = function(newState) {
      state = newState;
      $self.trigger('changed');
    };

    var makeSeed = function() {
      var seed = Item(self.game(), self.container());
      self.game().add(seed, 'item');
    };

    var die = function() {
      // Make one seed
      makeSeed();

      // Remove from cell
      self.container().remove(self);

      // Remove from game
      self.game().remove(self);
    };

    self = $.extend(Item(game, startingCell), {
      update: function() {
        age++;

        if(age == 100) {
          setState(Plant.state.small);
        } else if(age == 200) {
          setState(Plant.state.medium);
        } else if(age == 300) {
          setState(Plant.state.large);
        } else if(age == 400) {
          setState(Plant.state.bloom);
        } else if(age == 500) {
          die();
        }
      },

      image: function() {
        return 'plants/bush' + state;
      },

      state: function() {
        return state;
      }
    });
    
    $self = $(self);
    game.add(self, 'plant');
    return self;
  };

  Plant.state = {
    seed: '_seed',
    small: '0',
    medium: '1',
    large: '2',
    bloom: '3'
  };

  /*global Clock */
  Clock = function(game) {
    var $self;
    var age = 0;

    var self = $.extend(GameObject(game), {
      update: function() {
        age++;
        $self.trigger('changed');
      },

      age: function() {
        return age;
      }
    });

    $self = $(self);
    game.add(self, 'clock');

    return self;
  };

  /*global Creature */
  Creature = function(game, startingCell, options) {
    var self;
    var settings = $.extend({
      type: 'dog'
    }, options);

    var pickUp = function(object) {
      if(object && object != self) {
        self.add(object);
      }
    };

    self = $.extend(Item(game, startingCell), {
      update: function() {
        if(self.cell().contents().length > 1) {
          $.each(self.cell().contents(), function(i, object) {
            pickUp(object);
          });
        }

        if(self.onPath()) {
          self.followPath();
        } else if(rand(10) === 0) {
          self.randomMove();
        }
      },

      image: function() {
        return 'creatures/' + settings.type;
      }
    });

    Module.Container(self);
    Module.Pathfinder(self);

    game.addCreature(self);
    return self;
  };
})(jQuery);