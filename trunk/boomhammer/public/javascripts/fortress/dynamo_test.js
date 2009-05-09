/*global document, jQuery, rand, ok, test */

(function($) {
  $(document).ready(function() {
    test("#rand", function() {
      var n = rand(2);

      ok(n === 0 || n === 1, "rand(2) gives 0 or 1");
    });

    test("Array#rand", function() {
      var array = [1,2,3];

      ok(array.indexOf(array.rand()) != -1, "Array includes randomly selected element");
      ok([5].rand() === 5, "[5].rand() === 5");
      ok([].rand() === undefined, "[].rand() === undefined");
    });

    test("Array#remove", function() {
      ok([1,2,3].remove(2) === 2, "[1,2,3].remove(2) === 2");
      ok([1,3].remove(2) === undefined, "[1,3].remove(2) === undefined");
      ok([1,3].remove(3) === 3, "[1,3].remove(3) === 3");
      
      var array = [1,2,3];
      array.remove(2);
      ok(array.length === 2, "array = [1,2,3]; array.remove(2); array.length === 2");
      array.remove(3);
      ok(array.length === 1, "array = [1,3]; array.remove(3); array.length === 1");
    });

    test("Math.mod", function() {
      ok(Math.mod(0, 16) === 0, "0 mod 16 === 0");
      ok(Math.mod(15, 16) === 15, "15 mod 16 === 15");
      ok(Math.mod(-1, 16) === 15, "-1 mod 16 === 15");
    });

    test("Function#curry", function() {
      var add = function(a, b) {
        return a + b;
      };

      var add3 = add.curry(3);

      ok(add3(2) === 5, "Adding 3 to 2 when curried equals 5");
    });
  });
})(jQuery);