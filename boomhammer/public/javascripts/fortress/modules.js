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
            self.moveTo(self.container().neighbors().rand());
          }
        },

        onPath: function() {
          return path.length > 0;
        },

        pathTo: function(target) {
          var searchPath = aStar(self.cell(), target, self.game().heuristic);
          path = searchPath || [];
        },

        followPath: function() {
          if(!self.container()) {
            return;
          }

          if(path.length > 0) {
            var target = path.shift();

            if(self.container().neighbors().indexOf(target) > -1) {
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