/*global document, jQuery, rand, ok, equals, test */

(function($) {
  $(document).ready(function() {
    test("Mixins", function() {
      var Foo = function() {
        var self = this;

        self.getA = function() {
          return self.a;
        };

        return self;
      };

      var Bar = function() {
        var self = {
          a: 5
        };

        self.include(Foo);

        return self;
      }

      var obj = {a: 5};
      obj.include(Foo);
      equals(obj.a, obj.getA());

      var obj2 = Bar();
      equals(obj2.a, obj2.getA());
    });
  });
})(jQuery);