/*global jQuery, ok, equals, test */
(function($) {
  $(document).ready(function() {
    /**
     * Undefined is generally well behaved.
     */
    test("FUNdefined", function() {
      equals(undefined > 0, false);
      equals(undefined < 0, false);
      equals(undefined >= 0, false);
      equals(undefined <= 0, false);
      equals(undefined == 0, false);
      equals(undefined === 0, false);
      
      equals(undefined == null, true);
      equals(undefined == false, false);
      equals(undefined == true, false);

      equals(undefined === null, false);
      equals(undefined === false, false);
      equals(undefined === true, false);

      equals(undefined == undefined, true);
      equals(undefined >= undefined, false, "!");
      equals(undefined <= undefined, false, "!");

      equals((function(){})() === undefined, true);
    });

    /**
     * null is pretty weird. It's almost like zero but not equal to false,
     * and <= and >= many strange things.
     */
    test("null", function() {
      equals(null > 0, false);
      equals(null < 0, false);
      equals(null == 0, false);
      equals(null >= 0, true, "!!!");
      equals(null <= 0, true, "!!!");
      equals(null === 0, false);

      equals(null == false, false, "!!");
      equals(null >= false, true, "!!!");
      equals(null <= false, true, "!!!");

      equals(null > true, false);
      equals(null < true, true, "!!!");
      equals(null == true, false);
      equals(null >= true, false);
      equals(null <= true, true, "!!!");

      equals(null == undefined, true);
      equals(null >= undefined, false, "!");
      equals(null <= undefined, false, "!");

      equals(null == null, true);
      equals(null >= null, true);
      equals(null <= null, true);

      equals((function(){})() == null, true);
      equals((function(){})() === null, false, "It's actually `undefined`");
    });

    test("NaN a na na", function() {
      equals(typeof NaN, "number");
      equals(NaN == null, false);
      equals(NaN == undefined, false);
      equals(NaN == true, false);
      equals(NaN == false, false);
      equals(NaN == 0, false);
      equals(NaN == '', false);

      equals(NaN == NaN, false, "!!");
      equals(NaN === NaN, false, "!!!");
    });

    /**
     * It turns out that `true` is 'essentially' 1 and `false` is 'essentially' 0.
     */
    test("true and false", function() {
      equals(false > 0, false);
      equals(false < 0, false);
      equals(false == 0, true);
      equals(false >= 0, true);
      equals(false <= 0, true);
      equals(false == '0', true, "!");
      equals(false === 0, false);

      equals(true > 0, true);
      equals(true < 0, false);
      equals(true >= 0, true);
      equals(true <= 0, false);
      equals(true == 0, false);
      equals(true == 1, true, "!");
      equals(true == '1', true, "!!");
      equals(true == 2, false);
      equals(true === 0, false);
      equals(true === 1, false);

      equals(true > false, true);
      equals(true < false, false);
      equals(true >= false, true);
      equals(true <= false, false);
    });

    test("true and false math", function() {
      equals(5 + true, 6, true);
      equals(5 * true, 5, true);
      equals(5 - true, 4, true);

      equals(5 + false, 5, true);
      equals(5 * false, 0, true);
      equals(5 - false, 5, true);

      equals(false + false, 0, true);
      equals(true + false, 1, true);
      equals(true + true, 2, true);

      equals(false * false, 0, true);
      equals(true * false, 0, true);
      equals(true * true, 1, true);
    });

    /**
     * The secret to Array equality is that it gets converted to a string when compared with non-arrays.
     */
    test("false idols", function() {
      equals(0 == false, true);
      equals('' == false, true);
      equals(' ' == false, true);
      equals('0' == false, true);
      equals([] == false, true);
      
      equals(null == false, false, "!");
      equals(undefined == false, false, "!");
    });

    test("false Arrays", function() {
      equals([0] == false, true);
      equals([''] == false, true);
      equals([' '] == false, true);
      equals(['0'] == false, true);
      equals([[]] == false, true);
      equals([false] != false, true, "!!! The `toString()` is 'false'");
      equals([null] == false, true);
      equals([undefined] == false, true);

      // It goes on like that, the toString ends up as '0'
      equals([[[[[[[[[0]]]]]]]]] == false, true);

      // This adds weight to the toString hypothesis
      equals([{toString: function() {return '';}}] == false, true);
      equals([{toString: function() {return '0';}}] == false, true);
    });

    test("false Strings", function() {
      equals('                        ' == false, true);
      equals('            0.          ' == false, true);
      equals('0.0000000000000000000000' == false, true);
    });

    test("Boolean Goolean", function() {
      equals(Boolean(0) == false, true);
      equals(Boolean('') == false, true);
      equals(Boolean(' ') != false, true, "!!");
      equals(Boolean('0') != false, true, "!!");
      equals(Boolean([]) != false, true, "!!");
      equals(Boolean(null) == false, true, "!!");
      equals(Boolean(undefined) == false, true, "!!");
      equals(Boolean(NaN) == false, true, "!!");
      equals(Boolean(Boolean(false)) == false, true);
      equals(Boolean(new Boolean(false)) == true, true, "!!!");

      equals(new Boolean(0) == false, true);
      equals(new Boolean('') == false, true);
      equals(new Boolean(' ') != false, true);
      equals(new Boolean('0') != false, true);
      equals(new Boolean([]) != false, true);
      equals(new Boolean(null) == false, true);
      equals(new Boolean(undefined) == false, true);
      equals(new Boolean(new Boolean(false)) == true, true, "!!!");
    });

    test("Objects with toString methods defined that are equivalent to false", function() {
      equals({toString: function(){return false}} == false, true, "!!");
      equals({toString: function(){return null;}} == false, true, "!!");
      equals({toString: function(){return 0}} == false, true, "!!");
      equals({toString: function(){return '';}} == false, true, "!!");
      equals({toString: function(){return '0'}} == false, true, "!!");
      equals({toString: function(){return 'false'}} != false, true, "!!");
      equals({toString: function(){return undefined}} != false, true, "!!");
    });

    test("if statements", function() {
      var x;
      var ifX;

      x = undefined;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, false);
      if(x != false) { ifX = true; } else { ifX = false; }
      equals(ifX, true, "!!");

      x = null;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, false);
      if(x != false) { ifX = true; } else { ifX = false; }
      equals(ifX, true, "!!");

      x = false;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, false);

      x = true;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true)

      x = 0;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, false);

      x = NaN;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, false);
      if(x != false) { ifX = true; } else { ifX = false; }
      equals(ifX, true, "!!");

      x = '';
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, false);

      x = ' ';
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true);
      if(x != false) { ifX = true; } else { ifX = false; }
      equals(ifX, false, "!!");

      x = '0';
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true, "!");
      if(x != false) { ifX = true; } else { ifX = false; }
      equals(ifX, false, "!!");

      x = [];
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true, "!");
      if(x != false) { ifX = true; } else { ifX = false; }
      equals(ifX, false, "!!");

      x = {};
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true);

      x = {toString: function(){return '';}};
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true);

      x = new Boolean(false);
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true, "!!!")
      if(x != false) { ifX = true; } else { ifX = false; }
      equals(ifX, false, "!")
    });

    test("strings and numbers", function() {
      equals(0 == '', true)
      equals(0 == '0', true);
      equals(1 == '1', true);
      equals(-1 == '-1', true);
      equals(0 == '-0', true);
      equals(5 == '5', true);

      equals(0 == '0.0', true);
      equals(1 == '1.0', true);
      equals(-1 == '-1.0', true);
      equals(0 == '-0.0', true);
      equals(5 == '5.0', true);

      equals(0 == '0.', true);
      equals(1 == '1.', true);
      equals(-1 == '-1.', true);
      equals(0 == '-0.', true);
      equals(5 == '5.', true);

      equals(1 == '1.000000000000001', false);
      equals(1 == '1.0000000000000001', true, "!!");
      equals(
        '1.000000000000000001' ==
        '1.00000000000000001',
        false
      );

      equals(0 == '0.0000000000000000000000001', false, "!");
      equals(0 == '-0.0000000000000000000000001', false, "!");

      equals('0' == '-0', false);
    });
  });
})(jQuery);