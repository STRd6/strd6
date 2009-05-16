(function() {
  var prioritySortLow = function(a, b) {
    return b.priority - a.priority;
  };

  var prioritySortHigh = function(a, b) {
    return a.priority - b.priority;
  };

  /*global PriorityQueue */
  PriorityQueue = function(options) {
    var contents = [];

    var sorted = false;
    var sortStyle;

    if(options && options.low) {
      sortStyle = prioritySortLow;
    } else {
      sortStyle = prioritySortHigh;
    }

    var sort = function() {
      contents.sort(sortStyle);
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