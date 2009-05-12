(function($) {
  Engine = function() {
    // Private
    var loopHandle = false;
    var period = 100;
    var counter = 0;
    var width = 16;
    var height = 16;
    var cells = [];
    var objects = [];
    var creatures = [];

    // Torroidal
    var cellAtTorroidal = function(x, y) {
      return cells[Math.mod(y, height)*width + Math.mod(x, width)];
    };

    var update = function() {
      counter++;

      $.each(objects, function(i, object) {
        object.update();
      });
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
        return self;
      },

      addCell: function(cell) {
        cells.push(cell);
        return self;
      },

      addCreature: function(creature) {
        creatures.push(creature);
        return self;
      },

      cellAt: cellAtTorroidal,

      neighborsAt: function(x, y) {
        return [
          self.cellAt(x - 1, y),
          self.cellAt(x + 1, y),
          self.cellAt(x, y - 1),
          self.cellAt(x, y + 1)
        ];
      },

      configureCells: function() {
        // Set neighbors
        $.each(cells, function(index, cell) {
          var x = index % width;
          var y = Math.floor(index / width);
          cell.x = x;
          cell.y = y;
          cell.neighbors = self.neighborsAt(x, y);
        });
        return self;
      },

      cells: function() {
        return cells;
      },

      creatures: function() {
        return creatures;
      },

      objects: function() {
        return objects;
      },

      log: function(message) {
        console.log(message);
      }
    };

    return self;
  };
  
  GameObject = function(game) {
    var self = {
      // Empty update by default
      update: function() {},
      click: function() {}
    };

    game.add(self);
    return self;
  };
})(jQuery);