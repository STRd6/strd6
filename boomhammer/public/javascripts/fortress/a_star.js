/*global PriorityQueue */
(function() {
  var zeroHeuristic = function() {
    return 0;
  };

  function reconstructPath(cameFrom, currentNode) {
    if(cameFrom[currentNode]) {
      var path = reconstructPath(cameFrom, cameFrom[currentNode]);
      path.push(currentNode);
      return path;
    } else {
      return [];
    }
  }

  /*global aStar */
  /**
   * A* Search implementation.
   * 
   * Requires `PriorityQueue`.
   *
   * `start` and `goal` are nodes that must adhere to the following:
   *   unique toString() method for each instance.
   *   neighbors method that returns nodes neighbors
   *
   * The optional `heuristic` must accept two nodes as parameters and return a
   * non-negative number.
   *
   * The `heuristic` must be admissible. The estimated cost must
   * always be less than or equal to the actual cost of reaching the goal state.
   */
  aStar = function(start, goal, heuristic) {
    heuristic = heuristic || zeroHeuristic;

    var openSet = new PriorityQueue({low: true}); // The set of tentative nodes to be evaluated.
    var closedSet = {};
    var cameFrom = {};

    var gScore = {};
    var hScore = {};
    var fScore = {};

    gScore[start] = 0;
    hScore[start] = heuristic(start, goal);
    fScore[start] = gScore[start] + hScore[start]; // Estimated total distance from start to goal through y.

    openSet.push(start, fScore[start]);

    while(!openSet.empty()) {
      var currentNode = openSet.pop();
      
      if(currentNode === goal) {
        return reconstructPath(cameFrom, goal);
      }

      closedSet[currentNode] = true;

      var neighbors = currentNode.neighbors();
      for(var index = 0, len = neighbors.length; index < len; ++index) {
        var neighbor = neighbors[index];

        if(neighbor in closedSet) {
          // next
        } else {
          var distanceToNeighbor = 1;
          var gScoreTentative = gScore[currentNode] + distanceToNeighbor;
          var tentativeIsBetter = false;

          if(!openSet.includes(neighbor)) {
            hScore[neighbor] = heuristic(neighbor, goal);
            tentativeIsBetter = true;
          } else if(gScoreTentative < gScore[neighbor]) {
            tentativeIsBetter = true;
          }

          if(tentativeIsBetter === true) {
            cameFrom[neighbor] = currentNode;
            gScore[neighbor] = gScoreTentative;
            fScore[neighbor] = gScore[neighbor] + hScore[neighbor];
            openSet.push(neighbor, fScore[neighbor]);
          }
        }
      }
    }
    return null;
  };
})();