/**
 * JavaScript Core Extensions used by STRd6
 */

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