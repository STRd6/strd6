/*global document, jQuery, ok, test */

(function($) {
  $(document).ready(function() {
    test("Set#add", function() {
      var set = Set();

      set.add(2);
      equals(set.size(), 1);
      equals(set.includes(2), true);

      // Doesn't change state when adding to set again.
      set.add(2);
      equals(set.size(), 1);
      equals(set.includes(2), true);
    });

    test("Set#empty", function() {
      var set = Set();

      equals(set.size(), 0);
      equals(set.empty(), true);

      set.add(2);

      equals(set.size(), 1);
      equals(set.empty(), false);
    });

    test("Set#remove", function() {
      var set = Set();

      set.add(1);
      set.add(2);

      set.remove(2);
      equals(set.size(), 1);
      equals(set.empty(), false);

      // Don't change state when removing again
      set.remove(2);
      equals(set.size(), 1);
      equals(set.empty(), false);
    });
  });
})(jQuery);