# Provides
#   has_many :events
#   accepts_nested_attributes_for :events
#   #generate_event
#   #add_event
#   #select_from_weighted_distribution
module Eventful
  def self.included(model)
    model.class_eval do
      has_many :events, :as => :owner, :order => "weight DESC", :dependent => :destroy
      
      accepts_nested_attributes_for :events, :allow_destroy => true,
        :reject_if => proc {|attributes| attributes['weight'].to_i <= 0}
    end
  end

  # Returns a randomly selected event
  def generate_event
    return select_from_weighted_distribution(events.all)
  end

  # Returns self
  def add_event(base, weight=1)
    events.build :base => base, :weight => weight, :owner => self

    return self
  end

  protected
  # Return an element from an array of objects that each have a `weight` method
  # Returns elements with frequency = weight/distribution.sum(&:weight)
  #
  # Returns nil if distribution is empth
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
