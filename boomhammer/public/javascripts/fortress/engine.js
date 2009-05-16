/*global jQuery */
(function($) {
  /*global Engine */
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
    var $self;

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

      add: function(gameObject, type) {
        objects.push(gameObject);
        $self.trigger('objectAdded', [gameObject, type]);
        return self;
      },

      addCell: function(cell) {
        self.add(cell, 'cell');
        cells.push(cell);
        return self;
      },

      addCreature: function(creature) {
        self.add(creature, 'creature');
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

      remove: function(object) {
        var removedObject = objects.remove(object);

        if(removedObject !== undefined) {
          $self.trigger('objectRemoved', [removedObject]);
        }

        return removedObject;
      },

      log: function(message) {
        console.log(message);
      }
    };

    $self = $(self);

    return self;
  };

  /*global GameObject */
  GameObject = function(game) {
    var self = {
      // Empty update by default
      update: function() {},
      click: function() {},
      game: function() {return game;},
      image: function() {}
    };
    return self;
  };
})(jQuery);