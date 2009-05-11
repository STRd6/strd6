(function($) {
  PriorityQueue = function() {
    var contents = [];

    var prioritySort = function(a, b) {
      return a.priority - b.priority;
    };

    var self = {
      pop: function() {
        var element = contents.pop();

        if(element) {
          return element.object;
        } else {
          return undefined;
        }
      },

      size: function() {
        return contents.length;
      },

      empty: function() {
        return contents.length === 0;
      },

      push: function(object, priority) {
        contents.push({object: object, priority: priority});
        contents.sort(prioritySort);
      }
    };

    return self;
  };


})(jQuery);