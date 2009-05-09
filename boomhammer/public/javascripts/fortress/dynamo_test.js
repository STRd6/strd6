/*global document, jQuery, rand, ok, test */

(function($) {
  $(document).ready(function() {
    test("Random values", function() {
      var n = rand(2);

      ok(n === 0 || n == 1, "rand(2) gives 0 or 1");
    });

    test("Random Array Elements", function() {
      var array = [1,2,3];
      var emptyArray = [];

      ok(array.indexOf(array.rand()) != -1, "Array includes randomly selected element");
      ok(emptyArray.rand() === undefined, "Rand on empty array returns undefined");
    });

    test("Currying", function() {
      var add = function(a, b) {
        return a + b;
      };

      var add3 = add.curry(3);

      ok(add3(2) == 5, "Adding 3 to 2 when curried equals 5");
    });
  });
})(jQuery);