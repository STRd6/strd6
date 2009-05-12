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

    test("jQueryBug?", function() {
      var Container = function() {
        var contents = [];

        var self = {
          contents: function() {
            return contents;
          },

          add: function(object) {
            return contents.push(object);
          }
        };

        return self;
      };

      var Foo = function() {
        var self = {};
        var container;

        var log = function(object) {
          console.log(object);
        };

        return $.extend(self, {
          eachNeighbor: function() {
            $.each(self.container().contents(), function(i, element) {
              log(this);
            });
          },

          setContainer: function(newContainer) {
            container = newContainer;
          },

          container: function() {
            return container;
          }
        });

        return self;
      }

      var foo = new Foo();
      var container = Container();
      container.add({});
      container.add(foo);
      foo.setContainer(container);

      foo.eachNeighbor();

    });
  });
})(jQuery);