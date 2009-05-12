/*global console, document, game, jQuery, rand */

(function($) {
  Cell = function(game) {
    var state = Cell.state.dirt;

    // Inherit from GameObject
    var self = $.extend(GameObject(game), {
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
        $(self).trigger('changed');
      }
    });

    $.extend(self, Module.Container(self));

    game.addCell(self);
    return self;
  };

  Cell.state = {
    stone: 0,
    dirt: 1,
    water: 2
  };

  Item = function(game) {
    var self = $.extend(GameObject(game), {
      click: function(params) {
        var inventory = params.inventory;

        if(inventory) {
          inventory.add(self);
        }
      }
    });

    Module.Contianable(self);
    Module.Container(self);

    return self;
  };

  Plant = function(game, startingCell) {
    var age = rand(50);
    var state = Plant.state.seed;
    
    var setState = function(newState) {
      state = newState;
      $(self).trigger('changed');
    };

    var self = $.extend(new Item(game), {
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

    startingCell.add(self);

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
        $(self).trigger('changed');
      },

      age: function() {
        return age;
      }
    });

    return self;
  }

  Creature = function(game, startingCell) {
    var self;

    var pickUp = function(object) {
      if(object && object != self) {
        self.add(object);
      }
    };

    self = $.extend(Item(game), {
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

    Module.Pathfinder(self, startingCell);
    startingCell.add(self);

    game.addCreature(self);
    return self;
  };
})(jQuery);