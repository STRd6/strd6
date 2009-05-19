/*global document, jQuery, rand, ok, equals, test */

(function($) {
  $(document).ready(function() {
    test("Constructors", function() {
      equals({}.constructor, Object, "{}.constructor");
      equals([].constructor, Array, "[].constructor");
      equals(''.constructor, String, "''.constructor");
      equals((0).constructor, Number, "(0).constructor");
      equals((1.2).constructor, Number, "(1.2).constructor");
      equals(true.constructor, Boolean, "true.constructor");
      equals(false.constructor, Boolean, "false.constructor");
      equals((function(){}).constructor, Function, "anonymous function constructor");

      function A() { }
      var a = new A();
      equals(a.constructor, A, "a.constructor");

      function B() { }
      var b = new B();
      equals(b.constructor, B, "b.constructor");

      B.prototype = new A();
      var b2 = new B();

      equals(b.constructor, B, "Constructor for existing object does not change after changing prototypes");
      equals(b2.constructor, A, "Constructor for new objects changes after changing prototypes");

      function C() {}
      B.prototype = new C();
      var b3 = new B();

      equals(b3.constructor, C, "Constructor for new objects changes after changing prototypes again.");
    });

    test("Hash sux?", function() {
      var x = {};
      var y = {name: "My Cool Object"};
      var barbazfoo = {name: "My Uncool Object"};

      x['a'] = true;
      x['b'] = true;

      equals(x['a'], true);
      equals(x['b'], true);

      x[y] = y.name;
      x[barbazfoo] = barbazfoo.name;

      equals(x[y], barbazfoo.name, "That's right. We blew it up!");
      equals(x[barbazfoo], barbazfoo.name);
    });

    test("Instance Of", function() {
      function A() { }
      var a = new A();
      equals(a instanceof A, true, "A instanceof A");

      function B() { }
      var b = new B();
      equals(b instanceof B, true, "b instanceof B");

      B.prototype = new A();

      equals(b instanceof B, false, "b instanceof B NOT true after setting B.prototype = new A().");
      equals(b instanceof A, false, "b instanceof A NOT true...");

      var b2 = new B();
      ok(b2 instanceof A, "new objects are instances of prototype's class");

      equals(a instanceof Object, true, "We're all still instances of Object");
      equals(b instanceof Object, true, "We're all still instances of Object");
      equals(b2 instanceof Object, true, "We're all still instances of Object");
    });

    test("Prototypes instances", function() {
      function ProtoFoo() {
        // Private variable via closure
        var i = 0;

        // Public attribute
        this.i = 0;

        // Increment private and public variables
        this.inc = function() {
          i = i + 1;
          this.i = this.i + 1;
        };

        // Get private closure variable
        this.getProtoVal = function() {
          return i;
        };

        // Get public attribute
        this.getMyVal = function() {
          return this.i;
        };
      }

      function Foo() {}

      Foo.prototype = new ProtoFoo();

      var foo = new Foo();
      var bar = new Foo();

      equals(foo.getProtoVal(), 0);
      equals(foo.getMyVal(), 0);
      equals(bar.getProtoVal(), 0);
      equals(bar.getMyVal(), 0);

      bar.inc();
      bar.inc();

      equals(foo.getProtoVal(), 2);
      equals(foo.getMyVal(), 0);
      equals(bar.getProtoVal(), 2);
      equals(bar.getMyVal(), 2);

      // Here's where things get crazy
      var fooWithI = new Foo();
      fooWithI.i = 0;
      var fooWithoutI = new Foo();

      Foo.prototype.inc();

      equals(fooWithoutI.getMyVal(), 1, "GOTCHA: I don't have my own 'i' so I'm getting the value from the prototype object");
      equals(fooWithI.getMyVal(), 0, "i was already present, so I used my own");
      equals(bar.getProtoVal(), 3);
      equals(bar.getMyVal(), 2, "i was already present, so I used my own");

      var newFoo = new Foo();
      equals(newFoo.getMyVal(), 1, "Keep referencing the prototypes i value for as long as I don't have my own.");
      Foo.prototype.inc();
      equals(newFoo.getMyVal(), 2, "Keep referencing the prototypes i value for as long as I don't have my own.");
      Foo.prototype.inc();
      equals(newFoo.getMyVal(), 3, "Keep referencing the prototypes i value for as long as I don't have my own.");
    });

    test("Real OO JavaScript", function(){
      function ProtoFoo() {
        // Private variable via closure
        var i = 0;

        // Public attribute
        this.i = 0;

        // Increment private and public variables
        this.inc = function() {
          i = i + 1;
          this.i = this.i + 1;
        };

        // Get private closure variable
        this.getProtoVal = function() {
          return i;
        };

        // Get public attribute
        this.getMyVal = function() {
          return this.i;
        };
      }

      function Foo() {
        ProtoFoo.call(this);
      }

      var foo = new Foo();
      var bar = new Foo();

      equals(foo.getProtoVal(), 0);
      equals(foo.getMyVal(), 0);
      equals(bar.getProtoVal(), 0);
      equals(bar.getMyVal(), 0);

      bar.inc();
      bar.inc();

      equals(foo.getProtoVal(), 0, "No shared proto value");
      equals(foo.getMyVal(), 0);
      equals(bar.getProtoVal(), 2);
      equals(bar.getMyVal(), 2);

      foo.inc();

      equals(foo.getProtoVal(), 1);
      equals(foo.getMyVal(), 1);
      equals(bar.getProtoVal(), 2, "No shared proto value");
      equals(bar.getMyVal(), 2);
    });
  });
})(jQuery);