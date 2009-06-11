/*global jQuery, aStar */
(function($) {
  /*global Module */
  Module = {
    Container: function(includer) {
      var self = includer;
      var $self = $(self);
      var contents = [];

      return $.extend(self, {
        contents: function() { return contents; },
        add: function(object) {
          if(!object) {
            debugger;
          }

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

      $(self).bind('removedFromGame', function() {
        if(self.container()) {
          self.container().remove(self);
        }
      });

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
          if(target.state() == Cell.State.ground) {
            target.add(self);
          }
        },

        randomMove: function() {
          if(self.container() && self.container().neighbors) {
            self.moveTo(self.container().neighbors().rand());
            return true;
          } else {
            return false;
          }
        },

        onPath: function() {
          return path.length > 0;
        },

        pathTo: function(target) {
          var searchPath = aStar(self.cell(), target, self.heuristic, self.cellCost);
          path = searchPath || [];
        },

        followPath: function() {
          if(!self.container() || !self.onPath()) {
            return false;
          }

          if(path.length > 0) {
            var target = path.shift();

            if(self.container().neighbors().indexOf(target) > -1) {
              self.moveTo(target);
              return true;
            } else {
              // Path borkd!
              return false;
            }
          } else {
            return false;
          }
        }
      });

      return self;
    }
  };
})(jQuery);