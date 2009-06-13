(function($, F) {
  var cellData = F.generateCellData();

  $(function() {
    var action = 'path';
    var selectedCreature;
    digQueue = [];

    var clickParameters = function() {
      return {
        action: action,
        creature: selectedCreature,
        digQueue: digQueue
      };
    };

    var spriteUpdate = function(object, view) {
      var pic = object.image();
      view.css({backgroundImage: "url(/images/dungeon/"+pic+".png)"});
    };

    function createView(object, type) {
      return $('<div class="'+ type +' sprite"></div>').view(function() {
        return object;
      }, {
        update: spriteUpdate,
        clickParameters: clickParameters
      });
    }

    $('#panel .action').each(function() {
      var $this = $(this);
      var myAction = $this.html();

      if(myAction == action) {
        $this.addClass('selected');
      }
      
      $this
        .click(function() {
          action = myAction;
          $('#panel .action').removeClass('selected');
          $this.addClass('selected');
        })
        .css({backgroundImage: "url(/images/dungeon/"+ $this.html() +".png)"})
        .html('');
    });
    
    $('#trash').hide();

    game = new Engine();

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

      if(cell.state() == Cell.State.ground) {
        var roll = rand(4);
        if(roll === 0) {
          Plant(game, cell, {type: [Plant.Type.bush, Plant.Type.tree].rand()});
        } else if(roll === 1) {
          var seed = Item(game, cell, {type: 'seed', kind: [Plant.Type.bush, Plant.Type.tree].rand()});
          game.add(seed, {eventOptions: 'item'});
        }
      } else if(cell.state() == Cell.State.mountain && rand(5) === 0) {
        var item = Item(game, cell, {type: 'gem', kind: ['ruby', 'sapphire', 'emerald', 'gold'].rand()});
        game.add(item, {eventOptions: 'item'});
        cell.bury(item);
      }
    }

    game.configureCells();

    selectedCreature = F.Creature(game, game.cells().rand());

    F.Creature(game, game.cells().rand(), {type: 'raccoon'});
    F.Creature(game, game.cells().rand(), {type: 'raccoon'});
    F.Creature(game, game.cells().rand(), {type: 'chipmunk'});
    F.Creature(game, game.cells().rand(), {type: 'chipmunk'});
    F.Creature(game, game.cells().rand(), {type: 'chipmunk'});
    F.Creature(game, game.cells().rand(), {type: 'farmer'});

    Clock(game);

    game.start();
  });
})(jQuery, STRd6.Fortress);