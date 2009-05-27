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
    var activeObjects = [];
    var creatures = [];
    var $self;

    // TODO: use a better control mechanism
    var updating = false;

    // Torroidal
    var cellAtTorroidal = function(x, y) {
      return cells[Math.mod(y, height)*width + Math.mod(x, width)];
    };

    var heuristicTorroidal = function(a, b) {
      var x = Math.abs(a.x - b.x);
      var y = Math.abs(a.y - b.y);

      if(width - x < x) {
        x = width - x;
      }

      if(height - y < y) {
        y = height - y;
      }

      return x + y;
    }

    var update = function() {
      if(!updating) {
        updating = true;
        counter++;

        for(var index = 0, len = activeObjects.length; index < len; ++index) {
          var obj = activeObjects[index];
          if(obj) {
            obj.update();
          }
        }
        updating = false;
      }
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

      add: function(gameObject, type, active) {
        objects.push(gameObject);
        $self.trigger('objectAdded', [gameObject, type]);

        if(active) {
          activeObjects.push(gameObject);
        }
        
        return self;
      },

      addCell: function(cell) {
        self.add(cell, 'cell', false);
        cells.push(cell);
        return self;
      },

      addCreature: function(creature) {
        self.add(creature, 'creature', true);
        creatures.push(creature);
        return self;
      },

      cellAt: cellAtTorroidal,
      heuristic: heuristicTorroidal,

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
          cell.setNeighbors(self.neighborsAt(x, y));
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
        activeObjects.remove(object);
        var removedObject = objects.remove(object);

        if(removedObject !== undefined) {
          $self.trigger('objectRemoved', [removedObject]);
          $(removedObject).trigger('removedFromGame');
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

  (function() {
    var id = 0;

    /*global GameObject */
    GameObject = function(game) {
      var self = {
        // Empty update by default
        update: function() {},
        click: function() {},
        game: function() {return game;},
        image: function() {},
        objectId: '#<GameObject:' + (id++) + '>',
        toString: function() {
          return self.objectId;
        }
      };
      return self;
    };
  })();
})(jQuery);