class OpportunityBase < ActiveRecord::Base
  has_many :opportunities, :dependent => :destroy
  has_many :loots, 
    :order => "weight DESC",
    :dependent => :destroy

  validates_presence_of :name

  def spawn(attributes={})
    opportunity = Opportunity.new(attributes)
    opportunities << opportunity
    return opportunity
  end

  def generate_loot_item(roll)
    if loots.size > 0
      loots.each do |loot|
        return loot.item_base if roll < 0
        roll -= loot.weight
      end
      return loots.last.item_base
    else
      nil
    end
  end
end
