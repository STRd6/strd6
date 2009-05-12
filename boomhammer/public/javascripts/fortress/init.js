(function($) {
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

    $.each(game.cells(), function() {
      $('<div class="plant sprite"></div>').view(Plant.curry(game, this), {
        update: function(plant, view) {
          var pic = 'bush' + plant.state();
          view.css({background: "transparent url(/images/dungeon/plants/"+pic+".png)"});
        },

        initialize: function(model, view) {
          $(model).trigger('changed');
          $(model.container()).trigger('contentsAdded');
        }
      });
    });

    var cell = game.cells().rand();

    cell.view.append(
      $('<div class="creature sprite"></div>').view(Creature.curry(game, cell), {
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