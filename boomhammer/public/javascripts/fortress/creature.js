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

    function bury(item) {
      if(item && STRd6.rand(I.inventory.contents().length + 2) > 1) {
        self.cell().bury(item);
        return true;
      } else {
        return false;
      }
    }

    function wait() {
      return STRd6.rand(4) !== 0;
    }

    $.extend(self, {
      update: function() {
        if(pickUp(self.cell().rand())) {

        } else if(wait()) {

        } else if(self.followPath()) {

        } else if(bury(I.inventory.rand())) {

        } else if(self.randomMove()) {

        }
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

    game.addCreature(self);
    return self;
  };

  return Creature;
})(jQuery, STRd6.Fortress);