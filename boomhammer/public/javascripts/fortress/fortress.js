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
      var buried = Module.Container(GameObject());
      game.add(buried);

      // Inherit from GameObject
      var self = $.extend(GameObject(), {
        click: function(params) {
          switch(params.action) {
            case 'water':
              self.setState(State.water);

              $.each(self.neighbors, function(i, object) {
                object.setState(State.water);
              });
              break;
            case 'path':
              if(params.creature) {
                params.creature.pathTo(self);
              }
              break;
            case 'dig':
              if(state == State.mountain) {
                params.digQueue.push(self);
              }
              break;
          }
        },

        bury: function(object) {
          $(object).trigger('buried', [self, buried]);
        },

        dig: function() {
          if(state == State.mountain && rand(5) === 0) {
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
        },

        update: function() {
          if(state == State.water) {
            settings.variety = rand(3) + 1;
            $self.trigger('changed');
          }
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
    }, options);

    var type = settings.type;
    var kind = settings.kind;

    var makePlant = function(cell) {
      Plant(game, cell, {type: kind});
    };

    var self = $.extend(GameObject(), {
      click: function(params) {
        var inventory = params.inventory;

        if(inventory) {
          inventory.add(self);
        }
      },

      image: function() {
        return 'items/' + type + '/' + kind;
      },

      bury: function(cell, underground) {
        if(type == 'seed') {
          makePlant(cell);
          $(self).trigger("remove");
        } else {
          underground.add(self);
        }
      },
      
      gettableBy: function(getter) {
        if(self.container() == getter.container()) {
          return true;
        } else {
          return false;
        }
      }
    });

    Module.Containable(self, container);

    $(self).bind('buried', function(e, cell, underground) {
      self.bury(cell, underground);
    });

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
        var seed = Item(game, self.container(), {type: 'seed', kind: type});
        game.add(seed, {eventOptions: 'item'});
      };

      var die = function() {
        // Make one seed
        makeSeed();

        // Remove from game
        $self.trigger("remove");
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
            if(rand(100) === 0) {
              game.add(Item(game, startingCell, {type: 'food', kind: 'fruit'}), {eventOptions: 'item'});
            }
          } else if(age <= 500) {
            die();
          }
        },

        image: function() {
          return 'plants/' + type + state;
        },

        state: function() {
          return state;
        },

        gettableBy: function(getter) {
          return false;
        }
      });

      $self = $(self);
      game.add(self, {eventOptions: 'plant', updatable: true});
      return self;
    };

    Plant.State = State;
    Plant.Type = Type;
  })();

  /*global Clock */
  Clock = function(game) {
    var $self;
    var age = 0;

    var self = $.extend(GameObject(), {
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
    game.add(self, {eventOptions: 'clock', updatable: true});

    return self;
  };
})(jQuery);