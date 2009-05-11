/*global document, jQuery, rand, ok, test */

(function($) {
  $(document).ready(function() {
    test("AdjustableQueue#push", function() {
      var queue = AdjustableQueue();

      queue.push(2);
      
      ok(queue.size() === 1, "queue.size()")
      ok(!queue.empty(), "!queue.empty()")
    });

    test("AdjustableQueue#empty", function() {
      var queue = AdjustableQueue();

      ok(queue.size() === 0, "queue.size() === 0");
      ok(queue.empty(), "queue.empty()")

    });

    test("AdjustableQueue#best", function() {
      var queue = AdjustableQueue();
      var good = {cost: 2, benefit: 6};
      var decent = {cost: 3, benefit: 3};
      var bad = {cost: 10, benefit: 5};

      queue.push(good);
      queue.push(decent);
      queue.push(bad);

      ok(queue.best(function(e) {return e.benefit/e.cost}) == good, "Select best cost benefit ratio");
      ok(queue.best(function(e) {return e.cost/e.benefit}) == bad, "Select worst cost benefit ratio");
    });

    test("AdjustableQueue#popBest", function() {
      var queue = AdjustableQueue();
      var good = {cost: 2, benefit: 6};
      var decent = {cost: 3, benefit: 3};
      var bad = {cost: 10, benefit: 5};

      queue.push(good);
      queue.push(decent);
      queue.push(bad);

      ok(queue.popBest(function(e) {return e.benefit/e.cost}) == good, "Select best cost benefit ratio");
      ok(queue.popBest(function(e) {return e.benefit/e.cost}) == decent, "Select next best cost benefit ratio");
      ok(queue.popBest(function(e) {return e.benefit/e.cost}) == bad, "Select last best cost benefit ratio");
      ok(queue.empty(), "queue.empty()")

    });
  });
})(jQuery);