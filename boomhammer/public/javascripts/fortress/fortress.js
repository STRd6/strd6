/*global Module, GameObject, jQuery, rand */

(function($) {

  (function() {
    var State = {
      ground: 'ground',
      mountain: 'mountain',
      water: 'water'
    };

    /*global Cell */
    Cell = function(game, options) {
      var $self;

      var settings = $.extend({
        variety: rand(3) + 1,
        state: State.ground
      }, options);

      var state = settings.state;
      var neighbors = [];
      var buried = Module.Container(GameObject(game));
      game.add(buried);

      // Inherit from GameObject
      var self = $.extend(GameObject(game, 'cell'), {
        click: function(params) {

          if(params.action == 'water') {
            self.setState(State.water);

            $.each(self.neighbors, function(i, object) {
              object.setState(State.water);
            });
          } else if(params.action == 'path') {
            if(params.creature) {
              params.creature.pathTo(self);
            }
          } else if(params.action == 'dig') {
            self.dig();
          }
        },

        bury: function(object) {
          buried.add(object);
        },

        dig: function() {
          if(state == State.mountain && rand(5) == 0) {
            self.setState(State.ground);
            $.each(buried.contents(), function(i, object) {
              self.add(object);
            });
          }
        },

        state: function() {
          return state;
        },

        setState: function(newState) {
          if(newState != state) {
            state = newState;
            $self.trigger('changed');
          }
        },

        neighbors: function() {
          return neighbors;
        },

        setNeighbors: function(newNeighbors) {
          neighbors = newNeighbors;
        },

        image: function() {
          return 'terrain/' + state + settings.variety;
        }
      });

      $self = $(self);

      Module.Container(self);

      game.addCell(self);
      return self;
    };

    Cell.State = State;

  })();

  /*global Item */
  Item = function(game, container, options) {
    var settings = $.extend({
      type: 'gem',
      kind: 'ruby'
    }, options)

    var type = settings.type;
    var kind = settings.kind;

    var self = $.extend(GameObject(game), {
      click: function(params) {
        var inventory = params.inventory;

        if(inventory) {
          inventory.add(self);
        }
      },

      image: function() {
        return 'items/' + type + '/' + kind;
      }
    });

    Module.Containable(self, container);

    return self;
  };

  (function() {
    var State = {
      seed: '_seed',
      small: '0',
      medium: '1',
      large: '2',
      bloom: '3'
    };

    var Type = {
      bush: 'bush',
      tree: 'tree'
    };

    /*global Plant */
    Plant = function(game, startingCell, options) {
      var self;
      var $self;
      var state;

      var settings = $.extend({
        age: rand(50),
        state: State.seed,
        type: Type.bush
      }, options);

      var age = settings.age;
      var type = settings.type;

      var setState = function(newState) {
        if(state != newState) {
          state = newState;
          $self.trigger('changed');
        }
      };

      var makeSeed = function() {
        var seed = Item(self.game(), self.container(), {type: 'seed', kind: type});
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

          if(age <= 100) {
            setState(State.small);
          } else if(age <= 200) {
            setState(State.medium);
          } else if(age <= 300) {
            setState(State.large);
          } else if(age <= 400) {
            setState(State.bloom);
          } else if(age <= 500) {
            die();
          }
        },

        image: function() {
          return 'plants/' + type + state;
        },

        state: function() {
          return state;
        }
      });

      $self = $(self);
      game.add(self, 'plant');
      return self;
    };

    Plant.State = State;
    Plant.Type = Type;
  })();

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
      },

      image: function() {
        return 'terrain/mountain' + ((age % 3) + 1);
      }
    });

    $self = $(self);
    game.add(self, 'clock');

    return self;
  };

  /*global Creature */
  Creature = function(game, startingCell, options) {
    var settings = $.extend({
      type: 'dog'
    }, options);

    var inventory = Module.Container(GameObject(game));
    game.add(inventory, 'inventory');

    var self;
    var pickUp = function(object) {
      if(object && object != self) {
        inventory.add(object);
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

      cellCost: function(cell) {
        switch(cell.state()) {
          case Cell.State.ground:
            return 1;
            break;
          default:
            // undefined because: (undefined >= 0) === false
            return undefined;
            break;
        }
      },

      image: function() {
        return 'creatures/' + settings.type;
      }
    });

    Module.Pathfinder(self);

    game.addCreature(self);
    return self;
  };
})(jQuery);