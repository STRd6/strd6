/*global rand */

/*global DiamondSquare */
var DiamondSquare = function(times) {
  function perturbation() {
    return rand() - 0.5;
  }

  function insertNils(array) {
    var newArray = [];
    
    array.length.times(function(i) {
      newArray.push(array[i], 0.0);
    });

    return newArray;
  }

  function insertArrays(arrays) {
    var newArrays = [];

    arrays.length.times(function(i) {
      var a = arrays[i].map(function() { return 0; });
      newArrays.push(arrays[i], a);
    });
    
    return newArrays;
  }

  function computeFromAdjacents(arrays, iterator) {
    var n = arrays.length;
    n.times(function(row) {
      n.times(function(col) {
        if((row + col) % 2 === 0) {
          return; // NEXT
        }

        arrays[row][col] =
          iterator.call(null,
            arrays[Math.mod((row-1), n)][col],
            arrays[row][Math.mod((col-1), n)],
            arrays[row][Math.mod((col+1), n)],
            arrays[Math.mod((row+1), n)][col]
          );
      });
    });
  }

  function computeFromDiagonals(arrays, iterator) {
    var n = arrays.length;
    n.times(function(row) {
      if(row % 2 === 0) {
        return; // NEXT
      }

      n.times(function(col) {
        if(col % 2 === 0) {
          return; // NEXT
        }

        arrays[row][col] =
          iterator.call(null,
            arrays[Math.mod((row-1), n)][Math.mod((col-1), n)],
            arrays[Math.mod((row-1), n)][Math.mod((col+1), n)],
            arrays[Math.mod((row+1), n)][Math.mod((col-1), n)],
            arrays[Math.mod((row+1), n)][Math.mod((col+1), n)]
          );
      });
    });
  }

  function create(times) {
    var arrays = [[0.5]];

    var ratio = 2;

    times.times(function() {
      arrays = arrays.map(function(array) {
        return insertNils(array);
      });

      arrays = insertArrays(arrays);

      computeFromDiagonals(arrays, function(a, b, c, d) {
        return (a + b + c + d)/4 + perturbation()*ratio;
      });
      computeFromAdjacents(arrays, function(a, b, c, d) {
        return (a + b + c + d)/4 + perturbation()*ratio;
      });

      ratio *= 0.5;
    });

    return arrays;
  }

  return create(times);
};