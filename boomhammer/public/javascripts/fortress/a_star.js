/*global PriorityQueue */
(function() {
  /**
   * A method that always returns zero. Useful as a default heuristic to make
   * the search algorithm Djikstra's algorithm when no other heuristic is given.
   * @private
   * @returns 0
   */
  var zeroHeuristic = function() {
    return 0;
  };

  /**
   * A method that always returns one. Useful as the default cost to move
   * through a node if no other cost function is given.
   * @private
   * @returns 1
   */
  var oneCost = function() {
    return 1;
  }

  /**
   * A helper method to reconstruct the optimal path to the goal node.
   *
   * @private
   * @param cameFrom The node immediately previous to the current node.
   * @param currentNode The current node to reconstruct the path to.
   * @returns An array containing the path to and including currentNode.
   */
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
   *   unique toString() method for each node instance.
   *   neighbors method that returns nodes neighbors
   *
   * The optional `heuristic` must accept two nodes as parameters and return a
   * non-negative number.
   *
   * The `heuristic` must be admissible. The estimated cost must
   * always be less than or equal to the actual cost of reaching the goal state.
   */
  aStar = function(start, goal, heuristic, cost) {
    heuristic = heuristic || zeroHeuristic;
    cost = cost || oneCost;

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
          var costToNeighbor = cost(neighbor);

          if(costToNeighbor >= 0) {
            var gScoreTentative = gScore[currentNode] + costToNeighbor;
            var tentativeIsBetter = false;

            if(!openSet.includes(neighbor)) {
              hScore[neighbor] = heuristic(neighbor, goal);
              tentativeIsBetter = true;
            } else if(gScoreTentative < gScore[neighbor]) {
              tentativeIsBetter = true;
            }

            if(tentativeIsBetter) {
              cameFrom[neighbor] = currentNode;
              gScore[neighbor] = gScoreTentative;
              fScore[neighbor] = gScore[neighbor] + hScore[neighbor];
              openSet.push(neighbor, fScore[neighbor]);
            }
          }
        }
      }
    }
    return null;
  };

  /*global uniformCostSearch */
  /**
   * Uniform Cost Search implementation.
   *
   * Requires `PriorityQueue`.
   *
   * `start` is a node that must adhere to the following:
   *   unique toString() method for each node instance.
   *   neighbors method that returns nodes neighbors
   *
   * @param start The cell to start the search from.
   * @param goal {Function} Returns true if when passed a cell that cell is a goal cell.
   * @param cost {Function} Returns the cost of entering the passed in cell.
   */
  uniformCostSearch = function(start, goal, cost) {
    cost = cost || oneCost;

    var openSet = new PriorityQueue({low: true}); // The set of tentative nodes to be evaluated.
    var closedSet = {};
    var cameFrom = {};

    var gScore = {};

    gScore[start] = 0;

    openSet.push(start, gScore[start]);

    while(!openSet.empty()) {
      var currentNode = openSet.pop();

      if(goal(currentNode)) {
        return reconstructPath(cameFrom, currentNode);
      }

      closedSet[currentNode] = true;

      var neighbors = currentNode.neighbors();
      for(var index = 0, len = neighbors.length; index < len; ++index) {
        var neighbor = neighbors[index];

        if(neighbor in closedSet) {
          // next
        } else {
          var costToNeighbor = cost(neighbor);

          if(costToNeighbor >= 0) {
            var gScoreTentative = gScore[currentNode] + costToNeighbor;
            var tentativeIsBetter = false;

            if(!openSet.includes(neighbor)) {
              tentativeIsBetter = true;
            } else if(gScoreTentative < gScore[neighbor]) {
              tentativeIsBetter = true;
            }

            if(tentativeIsBetter === true) {
              cameFrom[neighbor] = currentNode;
              gScore[neighbor] = gScoreTentative;
              openSet.push(neighbor, gScore[neighbor]);
            }
          }
        }
      }
    }
    return null;
  }
})();