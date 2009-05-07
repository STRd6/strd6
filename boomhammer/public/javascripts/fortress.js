(function($) {
  function configureView(model, view, updateFunction) {
    // Handle to the view so that other views can update containment relations
    model.view = view;

    // Observe changes in the model
    var changed = true;
    var contentsAdded = true;

    $(model).bind("changed", function() {
      changed = true;
    });

    $(model).bind("contentsAdded", function() {
      contentsAdded = true;
    });

    // Pass click events to model
    view.bind('click', function() {
      model.click(clickParameters());
    });

    // update method called from controller to update this cell view
    view.update = function() {
      if(changed) {
        updateFunction(model, view);

        changed = false;
      }

      if(contentsAdded) {
        $.each(model.contents(), function() {
          view.append(this.view);
        });

        contentsAdded = false;
      }
    };
  }

  $.rand = function(x) {
	  return Math.floor(x * Math.random());
	}

  // View
  $.fn.view = function(game, controller, modelClass, updateFunction) {
    return this.each(function() {
      var $this = $(this);
      controller.add($this);

      // Create model
      var model = new modelClass(game);
      configureView(model, $this, updateFunction)
    });
  };

  Engine = function(updateController) {
    // Private
    var loopHandle = false;
    var period = 100;
    var counter = 0;
    var objects = [];
    var inventories = [];

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
      },

      addInventory: function(inventory) {
        inventories.push(inventory);
      },

      inventories: function() {
        return inventories;
      },

      log: function(message) {
        console.log(message);
      }
    };

    return self;
  };

  Cell = function(_game) {
    var game = _game;
    var state = Cell.state.dirt;
    var contents = [];

    var self = {
      update: function() {

      },

      click: function() {
        state = Cell.state.water;
        $(self).trigger('changed');
      },

      state: function() {
        return state;
      },

      contents: function() {
        return contents;
      }
    };

    game.add(self);

    return self;
  };

  Cell.state = {
    stone: 0,
    dirt: 1,
    water: 2
  };

  Item = function(game) {
    var contents = [];
    
    var self = {
      update: function() { },
      contents: function() { return contents; },
      click: function(params) {
        var inventory = params['inventory'];

        if(inventory) {
          inventory.add(self);
        }
      }
    }

    game.add(self);
    return self;
  };

  Inventory = function(game) {
    var contents = [];

    var self = {
      update: function() {},
      add: function(item) {
        contents.push(item);
        $(self).trigger('contentsAdded');
      },
      contents: function() { return contents;},
      click: function() {}
    }
    game.addInventory(self);
    return self;
  };

  UpdateController = function() {
    var _viewComponents = [];

    var self = {
      add: function(component) {
        _viewComponents.push(component);
      },

      update: function() {
        $.each(_viewComponents, function() {
          this.update();
        });
      }
    };

    return self;
  }

})(jQuery);

Plant = function(game) {
  var contents = [];
  var age = $.rand(50);
  var state = Plant.state.seed;

  var self = {
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
    contents: function() { return contents; },
    click: function(params) {
      var inventory = params['inventory'];

      if(inventory) {
        inventory.add(self);
      }
    },
    state: function() {
      return state;
    }
  }

  game.add(self);
  return self;
};

Plant.state = {
  seed: '_seed',
  small: '0',
  medium: '1',
  large: '2',
  bloom: '3'
};

function clickParameters() {
  return {
    inventory: game.inventories()[0]
  };
};

$(document).ready(function() {
  controller = new UpdateController();

  game = new Engine(controller);

  $('.cell').view(game, controller, Cell, function(cell, view) {
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
  });

  $('.item').view(game, controller, Item, function(item, view) {
    var pic = 'redgem';

    view.css({background: "transparent url(/images/dungeon/items/"+pic+".png)"});
  });

  $('.plant').view(game, controller, Plant, function(plant, view) {
    var pic = 'bush' + plant.state();

    if(pic) {
      view.css({background: "transparent url(/images/dungeon/plants/"+pic+".png)"});
    }
  });
  
  $('#inventory').view(game, controller, Inventory, function() {});

  game.start();
});