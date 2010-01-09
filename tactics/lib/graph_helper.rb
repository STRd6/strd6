module GraphHelper
  # A helper method to reconstruct the optimal path to the goal node.
  #
  # @private
  # @param cameFrom The node immediately previous to the current node.
  # @param currentNode The current node to reconstruct the path to.
  # @returns An array containing the path to and including currentNode.
  def self.reconstruct_path(cameFrom, currentNode)
    if(cameFrom[currentNode.to_s])
      path = reconstruct_path(cameFrom, cameFrom[currentNode.to_s])
      path.push(currentNode)
      return path
    else
      return [];
    end
  end

  # A* Search implementation.
  #
  # `start` and `goal` are nodes that must adhere to the following:
  #   unique toString() method for each node instance.
  #   neighbors method that returns nodes neighbors
  #
  # The optional `heuristic` must accept two nodes as parameters and return a
  # non-negative number.
  #
  # The `heuristic` must be admissible. The estimated cost must
  # always be less than or equal to the actual cost of reaching the goal state.
  def self.a_star(start, goal, heuristic=nil, cost=nil)
    heuristic ||= lambda { 0 }
    cost ||= lambda { 1 }

    open_set = [] # The set of tentative nodes to be evaluated.
    closed_set = {}
    came_from = {}

    g_score = {} # Actual distance
    h_score = {} # Estimated distance to goal
    f_score = {} # Estimated total distance from start to goal through node.

    g_score[start.to_s] = 0
    h_score[start.to_s] = heuristic.call(start, goal)
    f_score[start.to_s] = g_score[start.to_s] + h_score[start.to_s] 

    open_set.push(start)

    while(!open_set.empty?)
      open_set.sort_by do |node|
        f_score[node.to_s]
      end
      
      current_node = open_set.shift
      #puts "CUR: #{current_node}"
      #puts "CLO: #{closed_set.keys.sort.join(", ")}"
      #puts "OPE: #{open_set.join(", ")}"

      if(current_node == goal)
        return reconstruct_path(came_from, goal)
      end

      closed_set[current_node.to_s] = true

      current_node.neighbors.each do |neighbor|
        next if closed_set[neighbor.to_s]

        cost_to_neighbor = cost.call(neighbor)

        if cost_to_neighbor >= 0
          g_score_tentative = g_score[current_node.to_s] + cost_to_neighbor
          tentative_is_better = false

          #puts "G: #{g_score[neighbor]}"
          #puts "H: #{h_score[neighbor]}"

          if !open_set.include?(neighbor)
            h_score[neighbor.to_s] = heuristic.call(neighbor, goal)
            tentative_is_better = true
          elsif(g_score_tentative < g_score[neighbor.to_s])
            tentative_is_better = true
          end

          if tentative_is_better
            came_from[neighbor.to_s] = current_node
            g_score[neighbor.to_s] = g_score_tentative
            f_score[neighbor.to_s] = g_score[neighbor.to_s] + h_score[neighbor.to_s]
            open_set.push(neighbor)
          end
        end
        
      end
    end

    return nil
  end
end