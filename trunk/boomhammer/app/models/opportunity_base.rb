class OpportunityBase < ActiveRecord::Base
  include Requisite
  include WeightedDistribution

  has_many :opportunities, :dependent => :destroy
  has_many :loots, 
    :order => "weight DESC",
    :dependent => :destroy

  validates_presence_of :name

  accepts_nested_attributes_for :loots, :allow_destroy => true,
    :reject_if => proc {|attributes| attributes['weight'].to_i <= 0}

  def spawn(attributes={})
    opportunity = Opportunity.new(attributes)
    opportunities << opportunity
    return opportunity
  end

  def generate_loot_item()
    return select_from_weighted_distribution(loots.all).item_base
  end
end
