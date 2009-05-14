(function($) {
  Module = {
    Container: function(includer) {
      var self = includer;
      var $self = $(self);
      var contents = [];

      return $.extend(self, {
        contents: function() { return contents; },
        add: function(object) {
          if(object.container && object.container()) {
            object.container().remove(object);
          }

          contents.push(object);
          object.setContainer(self);
          $self.trigger('contentsAdded', [object]);
          return self;
        },
        remove: function(object) {
          return contents.remove(object);
        }
      });
    },

    Containable: function(includer, startingContainer) {
      var self = includer;
      var container = startingContainer;

      $.extend(self, {
        container: function() {
          return container;
        },

        setContainer: function(newContainer) {
          container = newContainer;
          return self;
        }
      });
      
      if(container) {
        container.add(self);
      }

      return self;
    },

    Pathfinder: function(includer) {
      var self = includer;
      var path = [];

      $.extend(self, {
        cell: function() {
          return self.container();
        },

        moveTo: function(target) {
          target.add(self);
        },

        randomMove: function() {
          if(self.container()) {
            self.moveTo(self.container().neighbors.rand());
          }
        },

        chooseBest: function(source, target, choices) {
          var deltaX = target.x - source.x;

          var good = [];

          if(deltaX > 0) {
            good = $.grep(choices, function(choice) {
              return choice.x - source.x > 0;
            });
          } else if(deltaX < 0) {
            good = $.grep(choices, function(choice) {
              return choice.x - source.x < 0;
            });
          }

          if(good.length > 0) {
            return good[0];
          }

          var deltaY = target.y - source.y;

          if(deltaY > 0) {
            good = $.grep(choices, function(choice) {
              return choice.y - source.y > 0;
            });
          } else if(deltaY < 0) {
            good = $.grep(choices, function(choice) {
              return choice.y - source.y < 0;
            });
          }

          if(good.length > 0) {
            return good[0];
          } else {
            return null;
          }
        },

        onPath: function() {
          return path.length > 0;
        },

        pathTo: function(target) {
          if(!self.container() || self.container() == target) {
            return;
          }

          path = [];

          var currentCell = self.container();
          var pathCell = self.chooseBest(currentCell, target, currentCell.neighbors);

          while(pathCell && pathCell != target) {
            path.push(pathCell);
            currentCell = pathCell;
            pathCell = self.chooseBest(currentCell, target, currentCell.neighbors);
          }
        },

        followPath: function() {
          if(!self.container()) {
            return;
          }

          if(path.length > 0) {
            var target = path.shift();

            if(self.container().neighbors.indexOf(target) > -1) {
              self.moveTo(target);
            } else {
              // Path borkd!
            }
          }
        }
      });

      return self;
    }
  };
})(jQuery);