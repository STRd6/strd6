(function($) {
  $(document).ready(function() {
    game = new Engine();

    var cellUpdate = function(cell, view) {
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
    };

    var itemUpdate = function(item, view) {
      var pic = item.image();
      view.css({background: "transparent url(/images/dungeon/items/"+pic+".png)"});
    };

    var plantUpdate = function(plant, view) {
      var pic = 'bush' + plant.state();
      view.css({background: "transparent url(/images/dungeon/plants/"+pic+".png)"});
    };

    var creatureUpdate = function(creature, view) {
      var pic = 'dog';
      view.css({background: "transparent url(/images/dungeon/"+pic+".png)"});
    };

    var clockUpdate = function(clock, view) {
      var pic = 'mountain' + ((clock.age() % 3) + 1);
      view.css({background: "transparent url(/images/dungeon/"+pic+".png)"});
    };

    function createView(object, type, update) {
      return $('<div class="'+ type +' sprite"></div>').view(function() {
        return object;
      }, {
        update: update
      });
    }

    $(game).bind('objectAdded', function(e, object, type) {
      switch(type) {
        case 'cell':
          $('#region').append(createView(object, type, cellUpdate));
          break;
        case 'item':
          createView(object, type, itemUpdate);
          break;
        case 'plant':
          createView(object, type, plantUpdate);
          break;
        case 'clock':
          $('#panel').append(createView(object, type, clockUpdate));
          break;
        case 'creature':
          createView(object, type, creatureUpdate);
          break;
      }
    });

    for(var i = 0; i < 256; i++) {
      var cell = Cell(game);
      Plant(game, cell);
    }

    game.configureCells();

    Creature(game, game.cells().rand());

    Clock(game);

    game.start();
  });
})(jQuery);