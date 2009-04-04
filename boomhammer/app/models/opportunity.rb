class Opportunity < ActiveRecord::Base
  include Named

  belongs_to :opportunity_base
  belongs_to :area

  validates_presence_of :opportunity_base
  validates_presence_of :area

  delegate :name, :to => :opportunity_base
  delegate :description, :to => :opportunity_base
  delegate :requisites, :to => :opportunity_base

  delegate :requisite_met?, :to => :opportunity_base
#  def requisite_met?(attributes)
#    opportunity_base.requisite_met? attributes
#  end
  
  def explore
    increment! :depletion

    roll = rand(100) - depletion
    if roll < 0
      nil
    else
      opportunity_base.generate_loot_item
    end
  end
end
