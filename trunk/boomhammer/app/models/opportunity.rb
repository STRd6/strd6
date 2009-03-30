class Opportunity < ActiveRecord::Base
  include Named

  belongs_to :opportunity_base
  belongs_to :area

  validates_presence_of :opportunity_base
  validates_presence_of :area
  
  def explore
    increment! :depletion

    roll = rand(100) - depletion
    if roll < 0
      nil
    else
      opportunity_base.generate_loot_item roll
    end
  end

  def name
    opportunity_base.name
  end
end
