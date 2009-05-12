/*global jQuery */

/**
 * Returns random integers from [0, n)
 */
function rand(n) {
  return Math.floor(n * Math.random());
}

/**
 * Ruby style mixins.
 *
 * var Foo = function() {
 *   this.include(Bar);
 * };
 *
Object.prototype.include = function(module) {
  if(!module || !module.apply) {
    return undefined;
  } else {
    return module.apply(this);
  }
};

Doesn't seem to work... strange interactions and hidden errors.
*/

/**
 * Return a random element from an array
 */
Array.prototype.rand = function() {
  return this[rand(this.length)];
};

/**
 * Remove the given object from the array if it is present and return the
 * removed object.
 * If the abject is not present in the array return undefined.
 */
Array.prototype.remove = function(object) {
  var index = this.indexOf(object);
  if(index >= 0) {
    return this.splice(index, 1)[0];
  } else {
    return undefined;
  }
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
  var defaults = {
    initialize: function(model) { $(model).trigger('changed'); },
    update: function() {},
    clickParameters: function() { return {}; }
  };

  function configureView(model, view, settings) {
    // Handle to the view so that other views can update containment relations
    model.view = view;

    // Observe changes in the model
    $(model).bind("changed", function() {
      settings.update(model, view);
    });

    $(model).bind("contentsAdded", function() {
      $.each(model.contents(), function(i, object) {
        if(object.view) {
          view.append(object.view);
        }
      });
    });

    // Pass click events to model
    view.bind('click', function() {
      model.click(settings.clickParameters());
    });

    settings.initialize(model, view);
  }

  // View
  $.fn.view = function(constructor, options) {
    var settings = $.extend({}, defaults, options);

    return this.each(function() {
      var $this = $(this);

      // Create model
      var model = constructor();
      configureView(model, $this, settings);
    });
  };
})(jQuery);