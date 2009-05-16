(function($) {
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
  aStar = function(start, goal, heuristic) {
    var closedSet = new Set();                    // The set of nodes already evaluated.
    var openSet = new PriorityQueue({low: true}); // The set of tentative nodes to be evaluated.
    var cameFrom = {};

    var gScore = {};
    var hScore = {};
    var fScore = {};

    gScore[start] = 0;
    hScore[start] = heuristic(start, goal);
    fScore[start] = gScore[start] + hScore[start]; // Estimated total distance from start to goal through y.

    openSet.push(start, fScore[start]);

    while(!openSet.empty()) {
      var currentNode = openSet.top();
      
      if(currentNode === goal) {
        //console.log(gScore);
        return reconstructPath(cameFrom, goal);
      }

      openSet.pop();
      closedSet.add(currentNode);

      //console.log(currentNode.neighbors());

      $.each(currentNode.neighbors(), function(i, neighbor) {
        if(closedSet.includes(neighbor)) {
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

          if(tentativeIsBetter == true) {
            cameFrom[neighbor] = currentNode;
            gScore[neighbor] = gScoreTentative;
            fScore[neighbor] = gScore[neighbor] + hScore[neighbor];
            openSet.push(neighbor, fScore[neighbor]);
          }
        }
      });
    }
    return null;
  };
})(jQuery);