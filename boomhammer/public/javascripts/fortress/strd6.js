/*global STRd6 */
STRd6 = (function() {
  var Fortress = {
    generateCellData: function() {
      var cellData = [];

      var cellHeights = DiamondSquare(4);

      var totalHeight = cellHeights.map(function(row) {
        return row.sum();
      }).sum();

      var avgHeight = totalHeight / 256;

      var state;
      var z = 0.2;

      for(var i = 0; i < 256; i++) {
        var cellHeight = cellHeights[i%16][Math.floor(i/16)];
        if(cellHeight > avgHeight + z) {
          state = Cell.State.mountain;
        } else if(cellHeight < avgHeight - z) {
          state = Cell.State.water;
        } else {
          state = Cell.State.ground;
        }

        cellData.push({
          variety: STRd6.rand(3) + 1,
          state: state
        });
      }

      return cellData;
    }
  };

  return {
    Fortress: Fortress,
    /**
     * Returns random integers from [0, n) if n is given.
     * Otherwise returns random float between 0 and 1.
     *
     * @param {Number} n
     */
    rand: function(n) {
      if(n) {
        return Math.floor(n * Math.random());
      } else {
        return Math.random();
      }
    }
  };
})();