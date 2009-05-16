(function($) {
  var cellData = [];

  for(var i = 0; i < 256; i++) {
    cellData.push({
      variety: rand(3) + 1,
      state: [Cell.State.ground, Cell.State.ground, Cell.State.ground, Cell.State.mountain, Cell.State.water].rand()
    });
  }

  $(document).ready(function() {
    $('#trash').hide();

    game = new Engine();

    var spriteUpdate = function(object, view) {
      var pic = object.image();
      view.css({background: "transparent url(/images/dungeon/"+pic+".png)"});
    };

    function createView(object, type) {
      return $('<div class="'+ type +' sprite"></div>').view(function() {
        return object;
      }, {
        update: spriteUpdate
      });
    }

    $(game).bind('objectAdded', function(e, object, type) {
      switch(type) {
        case 'cell':
          $('#region').append(createView(object, type));
          break;
        case 'clock':
          $('#panel').append(createView(object, type));
          break;
        case 'inventory':
          $('#inventories').append(createView(object, type));
          break;
        case 'creature':
        case 'item':
        case 'plant':
        default: 
          createView(object, type);
          break;
      }
    });

    $(game).bind('objectRemoved', function(e, object) {
      if(object && object.view) {
        $('#trash').append(object.view);
      }
    });

    for(var i = 0; i < 256; i++) {
      var cell = Cell(game, cellData[i]);

      if(cell.state() == Cell.State.ground && rand(3) === 0) {
        Plant(game, cell, {type: [Plant.Type.bush, Plant.Type.tree].rand()});
      }
    }

    game.configureCells();

    Creature(game, game.cells().rand());

    Clock(game);

    game.start();
  });
})(jQuery);