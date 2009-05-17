/*global jQuery, ok, equals, test */
(function($) {
  $(document).ready(function() {
    test("FUNdefined", function() {
      equals(undefined > 0, false);
      equals(undefined < 0, false);
      equals(undefined >= 0, false);
      equals(undefined <= 0, false);
      equals(undefined == 0, false);
      equals(undefined === 0, false);

      equals(null > 0, false);
      equals(null < 0, false);
      equals(null >= 0, true, "!!!");
      equals(null <= 0, true, "!!!");
      equals(null == 0, false);
      equals(null === 0, false);

      equals(false > 0, false);
      equals(false < 0, false);
      equals(false >= 0, true, "!");
      equals(false <= 0, true, "!");
      equals(false == 0, true, "!");
      equals(false === 0, false);

      equals(true > 0, true, "!");
      equals(true < 0, false);
      equals(true >= 0, true, "!");
      equals(true <= 0, false);
      equals(true == 0, false);
      equals(true == 1, true, "!");
      equals(true == 2, false);
      equals(true === 0, false);

      equals(undefined == null, true);
      equals(undefined == false, false);
      equals(undefined == true, false);

      equals(undefined === null, false);
      equals(undefined === false, false);
      equals(undefined === true, false);

      var x;

      equals(x == null, true);
      equals(x == undefined, true);
      equals(x == true, false);
      equals(x == false, false);
      equals(x === null, false);
      equals(x === undefined, true);
      equals(x === true, false);
      equals(x === false, false);

      var ifX
      if(x) { ifX = true; } else { ifX = false; }
      equals(ifX, false);

      var y = {};

      equals(y == null, false);
      equals(y == undefined, false);
      equals(y == true, false);
      equals(y == false, false);
      equals(y === null, false);
      equals(y === undefined, false);
      equals(y === true, false);
      equals(y === false, false);

      var ifY
      if(y) { ifY = true; } else { ifY = false; }
      equals(ifY, true);

      var a = [];

      equals(a == null, false);
      equals(a == undefined, false);
      equals(a == true, false);
      equals(a == false, true, "!");
      equals(a === null, false);
      equals(a === undefined, false);
      equals(a === true, false);
      equals(a === false, false);

      var ifA
      if(a) { ifA = true; } else { ifA = false; }
      equals(ifA, true);

      var s = '';

      equals(s == null, false);
      equals(s == undefined, false);
      equals(s == true, false);
      equals(s == false, true, "!");
      equals(s === null, false);
      equals(s === undefined, false);
      equals(s === true, false);
      equals(s === false, false);

      var ifS
      if(s) { ifS = true; } else { ifS = false; }
      equals(ifS, false, "!!");
    });
  });
})(jQuery);