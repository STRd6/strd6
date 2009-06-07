/*global jQuery */

/**
 * Returns random integers from [0, n) if n is given.
 * Otherwise returns random float between 0 and 1.
 *
 * @param {Number} n
 */
function rand(n) {
  if(n) {
    return Math.floor(n * Math.random());
  } else {
    return Math.random();
  }
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
 * Randomly select an element from the array.
 *
 * @return a random element from an array
 */
Array.prototype.rand = function() {
  return this[rand(this.length)];
};

/**
 * Remove the first occurance of the given object from the array if it is
 * present.
 * 
 * @param {Object} object The object to remove from the array if present.
 * @returns The removed object if present otherwise undefined.
 */
Array.prototype.remove = function(object) {
  var index = this.indexOf(object);
  if(index >= 0) {
    return this.splice(index, 1)[0];
  } else {
    return undefined;
  }
};

/**
 * Select the elements of the array for which iterator returns true.
 *
 * @param {Function} iterator
 * @param [context] Optional context parameter in which to call iterator.
 * @return The selected elements.
 */
Array.prototype.select = function(iterator, context) {
  var results = [];
  for(var i = 0; i < this.length; i++) {
    if (iterator.call(context, this[i], i)) {
      results.push(this[i]);
    }
  }
  return results;
};

/**
 * Sum the elements of the array.
 * @return The sum of the elements.
 */
Array.prototype.sum = function() {
  var sum = 0; // Identity element for + operator
  for(var i = 0; i < this.length; i++) {
    sum += this[i];
  }
  return sum;
};

/**
 * Call the given iterator once for each element in the array,
 * passing in the element as the first argument and the index as the second.
 *
 * @param {Function} iterator
 * @param [context] Optional context parameter in which to call iterator.
 * @return this for chaining.
 */
Array.prototype.eachWithIndex = function(iterator, context) {
  for(var i = 0; i < this.length; i++) {
    iterator.call(context, this[i], i);
  }
  return this;
};

Number.prototype.times = function(iterator, context) {
  for(var i = 0; i < this; i++) {
    iterator.call(context, i);
  }
  return i;
}

Function.prototype.curry = function() {
  var fn = this, args = Array.prototype.slice.call(arguments);

  return function() {
    return fn.apply(this, args.concat(Array.prototype.slice.call(arguments)));
  };
};

/**
 * Returns a mod useful for array wrapping.
 * Produces incorrect results if base and n are negative.
 *
 * @param {Number} n
 * @param {Number} base
 */
Math.mod = function(n, base) {
  var result = n % base;

  if(result < 0) {
    result += base;
  }

  return result;
};

(function($) {
  var defaults = {
    initialize: function(model) { 
      $(model).trigger('changed');
      if(model.container && model.container()) {
        $(model.container()).trigger('contentsAdded', [model]);
      }
    },
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

    $(model).bind("contentsAdded", function(e, object) {
      if(object && object.view) {
        view.append(object.view);
      }
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