(function($) {
  Engine = function(updateController) {
    // Private
    var loopHandle = false;
    var period = 100;
    var counter = 0;
    var width = 16;
    var height = 16;
    var cells = [];
    var objects = [];

    // Torroidal
    var cellAtTorroidal = function(x, y) {
      return cells[Math.mod(y, height)*width + Math.mod(x, width)];
    };

    var update = function() {
      counter++;

      $.each(objects, function() {
        this.update();
      });

      updateController.update();
    };

    // Public
    var self = {
      start: function() {
        if(loopHandle) {
          return;
        }

        loopHandle = setInterval(function() {
          update();
        }, period);
      },

      stop: function() {
        if(loopHandle) {
          clearTimeout(loopHandle);
          loopHandle = false;
        }
      },

      add: function(gameObject) {
        objects.push(gameObject);
        return self;
      },

      addCell: function(cell) {
        cells.push(cell);
        return self;
      },
      
      cellAt: cellAtTorroidal,

      neighborsAt: function(x, y) {
        return [
          self.cellAt(x - 1, y),
          self.cellAt(x + 1, y),
          self.cellAt(x, y - 1),
          self.cellAt(x, y + 1)
        ];
      },

      configureCells: function() {
        // Set neighbors
        $.each(cells, function(index, cell) {
          var x = index % width;
          var y = Math.floor(index / width);
          cell.x = x;
          cell.y = y;
          cell.neighbors = self.neighborsAt(x, y);
        });
        return self;
      },

      cells: function() {
        return cells;
      },

      objects: function() {
        return objects;
      },

      log: function(message) {
        console.log(message);
      }
    };

    return self;
  };

  GameObject = function(game) {
    var self = {
      // Empty update by default
      update: function() {},
      click: function() {}
    };

    game.add(self);
    return self;
  };

  Container = function(includer) {
    var contents = [];

    var self = {
      contents: function() { return contents; },
      add: function(object) {
        contents.push(object);
        $(includer).trigger('contentsAdded');
        return self;
      },
      remove: function(object) {
        contents.removeObject(object);
        return self;
      }
    };

    return self;
  }

  Cell = function(game) {
    var state = Cell.state.dirt;

    // Inherit from GameObject
    var self = $.extend(GameObject(game), {
      click: function() {
        state = Cell.state.water;

        $.each(self.neighbors, function() {
          this.setState(Cell.state.water);
        });

        $(self).trigger('changed');
      },

      state: function() {
        return state;
      },

      setState: function(newState) {
        state = newState;
        $(self).trigger('changed');
      }
    });

    $.extend(self, Container(self));

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
        var inventory = params['inventory'];

        if(inventory) {
          inventory.add(self);
        }
      }
    });

    $.extend(self, Container(self));

    return self;
  };

  UpdateController = function() {
    var viewComponents = [];

    var self = {
      add: function(component) {
        viewComponents.push(component);
      },

      update: function() {
        $.each(viewComponents, function() {
          this.update();
        });
      }
    };

    return self;
  }

  Plant = function(game) {
    var age = rand(50);
    var state = Plant.state.seed;

    var self = $.extend(new Item(game), {
      update: function() {
        age++;

        if(age == 100) {
          state = Plant.state.small;
          $(self).trigger('changed');
        } else if(age == 200) {
          state = Plant.state.medium;
          $(self).trigger('changed');
        } else if(age == 300) {
          state = Plant.state.large;
          $(self).trigger('changed');
        } else if(age == 400) {
          state = Plant.state.bloom;
          $(self).trigger('changed');
        }
      },
      state: function() {
        return state;
      }
    });

    return self;
  };

  Plant.state = {
    seed: '_seed',
    small: '0',
    medium: '1',
    large: '2',
    bloom: '3'
  };

  Creature = function(game, _cell) {
    var cell = _cell;

    var randomMove = function() {
      if(cell) {
        cell.remove(self);
        var target = cell.neighbors.rand();

        target.add(self);
        cell = target;
      }
    };

    var self = $.extend(Item(game), {
      update: function() {
        if(rand(10) == 0) {
          randomMove();
        }
        $(self).trigger('changed');
      }
    });

    return self;
  }

  function clickParameters() {
    return {
      
    };
  }

  $(document).ready(function() {
    controller = new UpdateController();

    game = new Engine(controller);

    $('.cell').view(controller, Cell.curry(game), {
      updateFunction: function(cell, view) {
        var pic = 'ground1';

        switch(cell.state()) {
          case Cell.state.stone:
            pic = 'mountain1';
            break;
          case Cell.state.dirt:
            pic = 'ground1';
            break;
          case Cell.state.water:
            pic = 'water1';
            break;
        }

        view.css({background: "transparent url(/images/dungeon/"+pic+".png)"});
      }
    });

    game.configureCells();

    $('.item').view(controller, Item.curry(game), {
      updateFunction: function(item, view) {
        var pic = 'redgem';

        view.css({background: "transparent url(/images/dungeon/items/"+pic+".png)"});
      }
    });

    $('.plant').view(controller, Plant.curry(game), {
      updateFunction: function(plant, view) {
        var pic = 'bush' + plant.state();

        if(pic) {
          view.css({background: "transparent url(/images/dungeon/plants/"+pic+".png)"});
        }
      }
    });

    var cell = game.cells().rand();

    cell.view.append(
      $('<div class="creature sprite abs"></div>').view(controller, Creature.curry(game, cell), {
        updateFunction: function(creature, view) {
          var pic = 'dog';

          view.css({background: "transparent url(/images/dungeon/"+pic+".png)"});
        }
      })
    );

    game.start();
  });

})(jQuery);