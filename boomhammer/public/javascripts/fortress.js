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
        updateFunction();

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

  // Cell view
  $.fn.cell = function(game, controller) {
    return this.each(function() {
      var $this = $(this);
      controller.add($this);

      // Create model
      var cell = new Cell(game);
      game.add(cell);

      var updateFunction = function() {
        var pic = 'ground1.png';

        switch(cell.state()) {
          case Cell.state.stone:
            pic = 'mountain1.png';
            break;
          case Cell.state.dirt:
            pic = 'ground1.png';
            break;
          case Cell.state.water:
            pic = 'water1.png';
            break;
        }

        $this.css({background: "transparent url(/images/dungeon/"+pic+")"});
      };

      configureView(cell, $this, updateFunction)
    });
  };

  // Item view
  $.fn.item = function(game, controller) {
    return this.each(function() {
      var $this = $(this);
      controller.add($this);

      // Create model
      var item = new Item(game);
      game.add(item);

      var updateFunction = function() {
        var pic = 'redgem.png';

        $this.css({background: "transparent url(/images/dungeon/items/"+pic+")"});
      };

      configureView(item, $this, updateFunction)
    });
  };

  // Inventory view
  $.fn.inventory = function(game, controller) {
    return this.each(function() {
      var $this = $(this);
      controller.add($this);

      // Create model
      var inventory = new Inventory(game);
      console.log("View created: " + inventory);
      game.addInventory(inventory);

      var updateFunction = function() {
        
      };

      configureView(inventory, $this, updateFunction)
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
        console.log(inventory);
        console.log(inventories[0]);
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
    var state = Cell.state.stone;
    var contents = [];

    var self = {
      update: function() {

      },

      click: function() {
        state = Cell.state.dirt;
        $(self).trigger('changed');
      },

      state: function() {
        return state;
      },

      contents: function() {
        return contents;
      }
    };

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

    return self;
  };

  Inventory = function() {
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

function clickParameters() {
  return {
    inventory: game.inventories()[0]
  };
};

jQuery.fn.clickTest = function() {
  return this.each(function(){
    var $this = $(this);
    $this.bind('click', function(){ alert('click');});
  });
};

$(document).ready(function() {
  mainView = new UpdateController();

  game = new Engine(mainView);

  $('.cell').cell(game, mainView);
  $('.item').item(game, mainView);
  $('#inventory').inventory(game, mainView);

  game.start();
});