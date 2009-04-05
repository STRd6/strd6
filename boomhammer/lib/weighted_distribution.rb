module WeightedDistribution
  def select_from_weighted_distribution(distribution)
    total_weight = distribution.sum(&:weight)

    roll = rand(total_weight)

    distribution.each do |outcome|
      return outcome if roll < outcome.weight
      roll -= outcome.weight
    end

    # In case of empty distribution or somesuch nonsense
    return distribution.last
  end
end
