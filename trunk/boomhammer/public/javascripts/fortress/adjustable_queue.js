(function($) {
  AdjustableQueue = function() {
    var contents = [];

    var self = {
      popBest: function(criteria) {
        var best = self.best(criteria);
        contents.remove(best);
        return best;
      },

      best: function(criteria) {
        var currentBest;
        var currentBestValue;

        if(contents.length > 0) {
          $.each(contents, function() {
            var value = criteria(this);

            if(currentBestValue === undefined || currentBestValue < value) {
              currentBestValue = value;
              currentBest = this;
            }
          });

          return currentBest;
        } else {
          return undefined;
        }
      },

      add: function(element) {
        return contents.push(element);
      }
    };

    return self;
  };


})(jQuery);