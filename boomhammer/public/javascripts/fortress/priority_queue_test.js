/*global document, jQuery, rand, ok, test */

(function($) {
  $(document).ready(function() {
    test("PriorityQueue#push", function() {
      var queue = PriorityQueue();

      queue.push(2, 5);

      ok(queue.size() === 1, "queue.size()")
      ok(!queue.empty(), "!queue.empty()")
    });

    test("PriorityQueue#empty", function() {
      var queue = PriorityQueue();

      ok(queue.size() === 0, "queue.size() === 0");
      ok(queue.empty(), "queue.empty()")

    });

    test("PriorityQueue#pop", function() {
      var queue = PriorityQueue();
      var good = {benefit: 6};
      var decent = {benefit: 3};
      var bad = {benefit: 1};

      queue.push(good, 10);
      queue.push(decent, 5);
      queue.push(bad, 1);

      equals(queue.pop(), good, "Start with best");
      equals(queue.pop(), decent, "then next best");
      equals(queue.pop(), bad, "then next");
    });
  });
})(jQuery);