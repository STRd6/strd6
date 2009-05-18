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
    });

    /**
     * null is pretty weird. It's almost like zero but not equal to false.
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

    test("false idols", function() {
      equals(0 == false, true);
      equals('' == false, true);
      equals('0' == false, true);
      equals([] == false, true);

      equals([0] == false, true);
      equals([''] == false, true);
      equals(['0'] == false, true);
      equals([[]] == false, true);

      // It goes on like that
      equals([[[[[[[[[0]]]]]]]]] == false, true);
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

      x = 0;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, false);

      x = '';
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, false);

      x = '0';
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true, "!!");
      if(x != false) { ifX = true; } else { ifX = false; }
      equals(ifX, false, "!!");

      x = [];
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true, "!!");
      if(x != false) { ifX = true; } else { ifX = false; }
      equals(ifX, false, "!!");

      x = {};
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true);

      x = true;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true)
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

    test('x is undefined', function(){
      var x;
      equals(x === undefined, true);

      equals(x == null, true);
      equals(x == undefined, true);
      equals(x == true, false);
      equals(x == false, false);

      var ifX;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, false);
    });

    test('x is null', function(){
      var x = null;
      equals(x === null, true);

      equals(x == null, true);
      equals(x == undefined, true);
      equals(x == true, false);
      equals(x == false, false);

      var ifX;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, false);
    });

    test('x is zero', function(){
      var x = 0;

      equals(x == null, false);
      equals(x == undefined, false);
      equals(x == true, false);
      equals(x == false, true);

      var ifX;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, false);
    });

    test('x is empty object', function() {
      var x = {};

      equals(x == null, false);
      equals(x == undefined, false);
      equals(x == true, false);
      equals(x == false, false);

      var ifX;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true);
    });

    test('x is empty array', function() {
      var x = [];

      equals(x == null, false);
      equals(x == undefined, false);
      equals(x == true, false);
      equals(x == false, true, "!");

      var ifX;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true);
    });

    test('x is array contiaining only empty string', function() {
      var x = [''];

      equals(x == null, false);
      equals(x == undefined, false);
      equals(x == true, false);
      equals(x == false, true, "!!");

      var ifX;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true);
    });

    test('x is array contiaining only empty array', function() {
      var x = [[]];

      equals(x == null, false);
      equals(x == undefined, false);
      equals(x == true, false);
      equals(x == false, true, "!!");

      var ifX;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true);
    });

    test('x is array contiaining only zero', function() {
      var x = [0];

      equals(x == null, false);
      equals(x == undefined, false);
      equals(x == true, false);
      equals(x == false, true, "!!");

      var ifX;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true);
    });

    test('x is array contiaining only two empty arrays', function() {
      var x = [[], []];

      equals(x == null, false);
      equals(x == undefined, false);
      equals(x == true, false);
      equals(x == false, false);

      var ifX;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true);
    });

    test('x is empty string', function() {
      var x = '';

      equals(x == null, false);
      equals(x == undefined, false);
      equals(x == true, false);
      equals(x == false, true, "!");

      var ifX;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, false, "!!");
    });

    test('x is string containing zero', function() {
      var x = '0';

      equals(x == null, false);
      equals(x == undefined, false);
      equals(x == true, false);
      equals(x == false, true, "!");

      var ifX;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true, "!");
    });

    test('x is string containing only multiple zeros', function() {
      var x = '000';

      equals(x == null, false);
      equals(x == undefined, false);
      equals(x == true, false);
      equals(x == false, true, "!");

      var ifX;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true);
    });

    test('x is string containing 1', function() {
      var x = '1';

      equals(x == null, false);
      equals(x == undefined, false);
      equals(x == true, true);
      equals(x == false, false);

      var ifX;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true);
    });

    test('x is string containing 5', function() {
      var x = '5';

      equals(x == null, false);
      equals(x == undefined, false);
      equals(x == true, false);
      equals(x == false, false);

      var ifX;
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, true);
    });
  });
})(jQuery);