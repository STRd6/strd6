/*global clearTimeout, console, document, game, jQuery, rand, setInterval */

(function($) {
  var Engine = function() {
    // Private
    var loopHandle = false;
    var period = 100;
    var counter = 0;
    var width = 16;
    var height = 16;
    var cells = [];
    var objects = [];
    var creatures = [];

    // Torroidal
    var cellAtTorroidal = function(x, y) {
      return cells[Math.mod(y, height)*width + Math.mod(x, width)];
    };

    var update = function() {
      counter++;

      $.each(objects, function() {
        this.update();
      });
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

      addCreature: function(creature) {
        creatures.push(creature);
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

      creatures: function() {
        return creatures;
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

  var GameObject = function(game) {
    var self = {
      // Empty update by default
      update: function() {},
      click: function() {}
    };

    game.add(self);
    return self;
  };

  var Module = {
    Container: function(includer) {
      var contents = [];

      var self = {
        contents: function() { return contents; },
        add: function(object) {
          contents.push(object);
          $(includer).trigger('contentsAdded');
          return self;
        },
        remove: function(object) {
          contents.remove(object);
          return self;
        }
      };

      return self;
    },

    Pathfinder: function(includer, startingCell) {
      var self = includer;
      var path = [];
      var cell = startingCell;

      $.extend(self, {
        moveTo: function(target) {
          if(cell) {
            cell.remove(self);
          }
          target.add(self);
          cell = target;
        },

        randomMove: function() {
          if(cell) {
            self.moveTo(cell.neighbors.rand());
          }
        },

        chooseBest: function(source, target, choices) {
          var deltaX = target.x - source.x;

          var good = [];

          if(deltaX > 0) {
            good = $.grep(choices, function(choice) {
              return choice.x - source.x > 0;
            });
          } else if(deltaX < 0) {
            good = $.grep(choices, function(choice) {
              return choice.x - source.x < 0;
            });
          }

          if(good.length > 0) {
            return good[0];
          }

          var deltaY = target.y - source.y;

          if(deltaY > 0) {
            good = $.grep(choices, function(choice) {
              return choice.y - source.y > 0;
            });
          } else if(deltaY < 0) {
            good = $.grep(choices, function(choice) {
              return choice.y - source.y < 0;
            });
          }

          if(good.length > 0) {
            return good[0];
          } else {
            return null;
          }
        },

        onPath: function() {
          return path.length > 0;
        },

        pathTo: function(target) {
          if(!cell || cell == target) {
            return;
          }

          path = [];

          var currentCell = cell;
          var pathCell = self.chooseBest(currentCell, target, currentCell.neighbors);

          while(pathCell && pathCell != target) {
            path.push(pathCell);
            currentCell = pathCell;
            pathCell = self.chooseBest(currentCell, target, currentCell.neighbors);
          }
        },

        followPath: function() {
          if(!cell) {
            return;
          }

          if(path.length > 0) {
            var target = path.shift();

            if(cell.neighbors.indexOf(target) > -1) {
              self.moveTo(target);
            } else {
              // Path borkd!
            }
          }
        }
      });
    }
  };

  var Cell = function(game) {
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

    $.extend(self, Module.Container(self));

    game.addCell(self);
    return self;
  };

  Cell.state = {
    stone: 0,
    dirt: 1,
    water: 2
  };

  var Item = function(game) {
    var self = $.extend(GameObject(game), {
      click: function(params) {
        var inventory = params.inventory;

        if(inventory) {
          inventory.add(self);
        }
      }
    });

    $.extend(self, Module.Container(self));

    return self;
  };

  var Plant = function(game) {
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

  var Clock = function(game) {
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

  var Creature = function(game, startingCell) {
    var self;

    self = $.extend(Item(game), {
      update: function() {
        if(self.onPath()) {
          self.followPath();
        }else if(rand(10) === 0) {
          self.randomMove();
        }
      }
    });

    $.extend(self, Module.Pathfinder(self, startingCell));

    game.addCreature(self);
    return self;
  };

  function clickParameters() {
    return {
      
    };
  }

  $(document).ready(function() {
    game = new Engine();

    $('.cell').view(Cell.curry(game), {
      update: function(cell, view) {
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

    $('.item').view(Item.curry(game), {
      update: function(item, view) {
        var pic = 'redgem';

        view.css({background: "transparent url(/images/dungeon/items/"+pic+".png)"});
      }
    });

    $('.plant').view(Plant.curry(game), {
      update: function(plant, view) {
        var pic = 'bush' + plant.state();

        if(pic) {
          view.css({background: "transparent url(/images/dungeon/plants/"+pic+".png)"});
        }
      }
    });

    var cell = game.cells().rand();

    cell.view.append(
      $('<div class="creature sprite abs"></div>').view(Creature.curry(game, cell), {
        update: function(creature, view) {
          var pic = 'dog';

          view.css({background: "transparent url(/images/dungeon/"+pic+".png)"});
        }
      })
    );

    $('.clock').view(Clock.curry(game), {
      update: function(clock, view) {
        var pic = 'mountain' + ((clock.age() % 3) + 1);

        view.css({background: "transparent url(/images/dungeon/"+pic+".png)"});
      }
    });

    game.start();
  });

})(jQuery);