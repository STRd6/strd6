/*global document, jQuery, rand, ok, equals, test */

(function($) {
  $(document).ready(function() {
    test("Adding item to Cells", function() {
      var game = Engine();
      var cell1 = Cell(game);
      var cell2 = Cell(game);
      var item = Item(game);

      cell1.add(item);

      ok(cell1.contents().indexOf(item) != -1, "Cell should contain item");
      ok(item.container() == cell1, "The contianer of the item should be the cell");

      cell2.add(item);
      
      ok(cell1.contents().indexOf(item) == -1, "cell1 should not contain item");
      ok(item.container() != cell1, "The contianer of the item should not be the cell1");
      ok(cell2.contents().indexOf(item) != -1, "cell2 should contain item");
      ok(item.container() == cell2, "The contianer of the item should be cell2");
    });
  });
})(jQuery);