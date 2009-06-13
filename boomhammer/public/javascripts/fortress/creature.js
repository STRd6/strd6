/*global jQuery, STRd6 */
STRd6.Fortress.Creature = (function($, F) {
  var Creature = function(game, startingCell, options) {
    var settings = $.extend({
      type: 'dog'
    }, options);

    var inventory = Module.Container(GameObject());
    game.add(inventory, {eventOptions: 'inventory'});

    var self;

    function pickUp(object) {
      if(object) {
        if(object.gettableBy(self)) {
          inventory.add(object);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }

    function bury(item) {
      if(item && STRd6.rand(inventory.contents().length + 2) > 1) {
        self.cell().bury(item);
        return true;
      } else {
        return false;
      }
    }

    function wait() {
      return STRd6.rand(4) !== 0;
    }

    var fullLevel = 500;
    var foodLevel = 300;
    var hungerLevel = 100;

    var hungry = function() {
      return foodLevel < hungerLevel;
    };

    var hasFood = function() {
      var foodCount = 0;

      inventory.contents().eachWithIndex(function(item) {
        if(item.type == "food") {
          foodCount++;
        }
      });

      return foodCount > 0;
    };

    function eatFood() {

    }

    function findFood() {

    }

    var thinkAndAct = function() {
      if(hungry()) {
        if(hasFood()) {
          eatFood();
        } else {
          findFood();
        }
      } else {
        plantSeed();
      }
    };

    self = $.extend(Item(game, startingCell), {
      update: function() {
        if(pickUp(self.cell().contents().rand())) {

        } else if(wait()) {

        } else if(self.followPath()) {

        } else if(bury(inventory.contents().rand())) {

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
        return 'creatures/' + settings.type;
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