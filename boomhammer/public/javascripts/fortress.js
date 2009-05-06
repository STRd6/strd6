(function($) {
  // Cell view
  $.fn.cell = function(game, updateController) {
    console.log("Ahay");

    return this.each(function() {
      var $this = $(this);
      var hasChanged = true;

      // Create model
      var cell = new Cell(game);
      $this.cell = cell;

      game.add(cell);
      updateController.add($this);

      $(cell).bind("changed", function() {
        hasChanged = true;
      });

      // Pass events to model
      $this.bind('click', function() {
        console.log("t1");
        cell.click();
      });

      $this.update = function() {
        if(!hasChanged) {
          return;
        }
        
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

        hasChanged = false;
      };

    });
  };

  Engine = function(updateController) {
    // Private
    var _loopHandle = false;
    var _period = 100;
    var _counter = 0;
    var _objects = [];

    var update = function() {
      _counter++;

      $.each(_objects, function() {
        this.update();
      });

      updateController.update();
    };

    // Public
    var self = {
      start: function() {
        if(_loopHandle) {
          return;
        }

        _loopHandle = setInterval(function() {
          update();
        }, _period);
      },

      stop: function() {
        if(_loopHandle) {
          clearTimeout(_loopHandle);
          _loopHandle = false;
        }

        self.log("stop");
      },

      add: function(gameObject) {
        _objects.push(gameObject);
      },

      log: function(message) {
        console.log(message);
      }
    };

    return self;
  };

  Cell = function(game) {
    var _game = game;
    var _n = 0;
    var _state = Cell.state.stone;

    var self = {
      update: function() {
//        if(_n > 0) {
//          _n = _n - 1;
//          $(self).trigger('changed');
//        }
      },

      click: function() {
        _state = Cell.state.dirt;
        $(self).trigger('changed');
      },

      n: function() {
        return _n;
      },

      state: function() {
        return _state;
      }
    };

    return self;
  };

  Cell.state = {
    stone: 0,
    dirt: 1,
    water: 2
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

  game.start();
});