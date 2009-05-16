(function() {
  /*global PriorityQueue */
  PriorityQueue = function() {
    var contents = [];

    var sorted = false;

    var prioritySort = function(a, b) {
      return a.priority - b.priority;
    };

    var sort = function() {
      contents.sort(prioritySort);
      sorted = true;
    };

    var self = {
      pop: function() {
        if(!sorted) {
          sort();
        }

        var element = contents.pop();

        if(element) {
          return element.object;
        } else {
          return undefined;
        }
      },
      
      top: function() {
        if(!sorted) {
          sort();
        }

        var element = contents[contents.length - 1];

        if(element) {
          return element.object;
        } else {
          return undefined;
        }
      },

      includes: function(object) {
        for(var i = contents.length - 1; i >= 0; i--) {
          if(contents[i].object === object) {
            return true;
          }
        }

        return false;
      },

      size: function() {
        return contents.length;
      },

      empty: function() {
        return contents.length === 0;
      },

      push: function(object, priority) {
        contents.push({object: object, priority: priority});
        sorted = false;
      }
    };

    return self;
  };
})();