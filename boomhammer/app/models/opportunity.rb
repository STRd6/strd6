class Opportunity < ActiveRecord::Base
  include Named

  belongs_to :opportunity_base
  belongs_to :area

  validates_presence_of :opportunity_base
  validates_presence_of :area

  delegate :name,
    :description,
    :requisites,
    :requisites_met?,
    :can_be_discovered_by?,
    :to => :opportunity_base
  
  def explore
    roll = rand(100) - depletion
    if roll < 0
      nil
    else
      increment! :depletion
      opportunity_base.generate_loot_item
    end
  end
end
