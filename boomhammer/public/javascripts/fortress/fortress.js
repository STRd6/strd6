/*global console, document, game, jQuery, rand */

(function($) {
  Cell = function(game) {
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

    var $self = $(self);

    Module.Container(self);

    game.addCell(self);
    return self;
  };

  Cell.state = {
    stone: 0,
    dirt: 1,
    water: 2
  };

  Item = function(game, container) {
    var self = $.extend(GameObject(game), {
      click: function(params) {
        var inventory = params.inventory;

        if(inventory) {
          inventory.add(self);
        }
      }
    });

    Module.Containable(self, container);

    return self;
  };

  Plant = function(game, startingCell) {
    var age = rand(50);
    var state = Plant.state.seed;

    var self = $.extend(Item(game, startingCell), {
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
        }
      },

      state: function() {
        return state;
      }
    });
    
    var $self = $(self);

    var setState = function(newState) {
      state = newState;
      $self.trigger('changed');
    };

    var makeSeed = function() {
      var seed = Item(self.game(), self.container());

      $('<div class="item sprite"></div>').view(function(){
        return seed;
      }, {
        update: function(item, view) {
          var pic = 'bush_seed';

          view.css({background: "transparent url(/images/dungeon/plants/"+pic+".png)"});
        }
      });
    };

    var die = function() {
      // Make one seed
      makeSeed();

      // Remove from cell / add to discard


      // Remove from game
      self.game().remove(self);
    };

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

  Clock = function(game) {
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

    var $self = $(self);
    game.add(self, 'clock');

    return self;
  }

  Creature = function(game, startingCell) {
    var self;

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
      }
    });

    Module.Container(self);
    Module.Pathfinder(self);

    game.addCreature(self);
    return self;
  };
})(jQuery);