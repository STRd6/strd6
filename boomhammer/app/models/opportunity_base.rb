class OpportunityBase < ActiveRecord::Base
  include Requisite

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
    total_weight = loots.all.sum(&:weight)

    roll = rand(total_weight)

    loots.each do |outcome|
      roll -= outcome.weight
      return outcome.item_base if roll <= 0
    end

    return loots.last.item_base
  end
end
