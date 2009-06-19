/*global jQuery, STRd6 */
STRd6.Fortress.Creature = (function($, F) {
  var Creature = function(game, startingCell, options) {
    var self = Item(game, startingCell);
    var I = self.I;

    $.extend(I, {
      type: 'dog'
    }, options);

    I.inventory = Module.Container(GameObject());
    game.add(I.inventory, {eventOptions: 'inventory'});

    function pickUp(object) {
      if(object) {
        if(object.gettableBy(self)) {
          I.inventory.add(object);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }

    function pickUpRandom() {
      return pickUp(self.cell().rand());
    }

    function bury(item) {
      if(item) {
        self.cell().bury(item);
        return true;
      } else {
        return false;
      }
    }

    function buryRandom() {
      if(STRd6.rand(I.inventory.size() + 2) > 1) {
        return bury(I.inventory.rand());
      } else {
        return false;
      }
    }

    function wait() {
      return STRd6.rand(4) !== 0;
    }

    var AI;

    $.extend(self, {
      update: function() {
        var i = 0;

        while(i < AI.length) {
          if(AI[i].call(self)) {
            return true;
          }
          i++;
        }

        return false;
      },

      cellCost: function(cell) {
        if(cell.state() === Cell.State.ground) {
          return 1;
        } else {
          // undefined because: (undefined >= 0) === false
          return undefined;
        }
      },

      heuristic: game.heuristic,

      image: function() {
        return 'creatures/' + I.type;
      },

      bury: function(cell, underground) {
        cell.add(self);
      },

      gettableBy: function(getter) {
        return false;
      },

      click: function() {
        $(self.view).addClass('ghost');
      }
    });

    Module.Pathfinder(self);

    AI = [pickUpRandom, self.followPath, wait, buryRandom, self.randomMove];

    game.addCreature(self);
    return self;
  };

  return Creature;
})(jQuery, STRd6.Fortress);