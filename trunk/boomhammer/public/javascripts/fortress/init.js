(function($) {
  $(document).ready(function() {
    $('#trash').hide();

    game = new Engine();

    var spriteUpdate = function(object, view) {
      var pic = object.image();
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
          $('#region').append(createView(object, type, spriteUpdate));
          break;
        case 'clock':
          $('#panel').append(createView(object, type, spriteUpdate));
          break;
        case 'inventory':
          $('#inventories').append(createView(object, type, function(){}));
          break;
        case 'creature':
        case 'item':
        case 'plant':
        default: 
          createView(object, type, spriteUpdate);
          break;
      }
    });

    $(game).bind('objectRemoved', function(e, object) {
      if(object && object.view) {
        $('#trash').append(object.view);
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