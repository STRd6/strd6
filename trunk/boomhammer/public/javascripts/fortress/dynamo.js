/**
 * Returns random integers from [0, n)
 */
function rand(n) {
  return Math.floor(n * Math.random());
}

/**
 * Return a random element from an array
 */
Array.prototype.rand = function() {
  return this[rand(this.length)];
};

Array.prototype.removeObject = function(object) {
  return this.slice(this.indexOf(object), 1);
};

Function.prototype.curry = function() {
  var fn = this, args = Array.prototype.slice.call(arguments);

  return function() {
    return fn.apply(this, args.concat(Array.prototype.slice.call(arguments)));
  };
};

// Fixing modulo operator (positive base only)
Math.mod = function(n, base) {
  var result = n % base;

  if(result < 0) {
    result += base;
  }

  return result;
};

(function($) {
  function configureView(model, view, settings) {
    // Handle to the view so that other views can update containment relations
    model.view = view;

    // Observe changes in the model
    var changed = true;
    var contentsAdded = true;

    $(model).bind("changed", function() {
      changed = true;
    });

    $(model).bind("contentsAdded", function() {
      contentsAdded = true;
    });

    // Pass click events to model
    view.bind('click', function() {
      model.click(settings.clickParameters());
    });

    // update method called from controller to update this cell view
    view.update = function() {
      if(changed) {
        settings.updateFunction(model, view);

        changed = false;
      }

      if(contentsAdded) {
        $.each(model.contents(), function() {
          view.append(this.view);
        });

        contentsAdded = false;
      }
    };
  }

  // View
  $.fn.view = function(controller, constructor, options) {
    var defaults = {
      updateFunction: function() {},
      clickParameters: function() { return {}; }
    };

    var settings = $.extend(defaults, options);

    return this.each(function() {
      var $this = $(this);
      controller.add($this);

      // Create model
      var model = constructor();
      configureView(model, $this, settings);
    });
  };
})(jQuery);