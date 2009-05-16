(function() {
  Set = function() {
    var contents = [];

    var self = {
      add: function(object) {
        if(self.includes(object)) {
          return;
        } else {
          contents.push(object);
        }
      },

      size: function() {
        return contents.length;
      },

      empty: function() {
        return contents.length == 0;
      },

      remove: function(object) {
        contents.remove(object);
      },

      includes: function(object) {
        return contents.indexOf(object) != -1;
      }
    };

    return self;
  };
})();