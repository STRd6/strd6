class Opportunity < ActiveRecord::Base
  include Named

  belongs_to :opportunity_base
  belongs_to :area

  has_one :image, :through => :opportunity_base

  validates_presence_of :opportunity_base
  validates_presence_of :area

  delegate :name,
    :description,
    :requisites,
    :requisites_met?,
    :can_be_discovered_by?,
    :to => :opportunity_base

  # Returns a random event or nil
  # increments depletion if an event is returned
  def explore
    roll = rand(100) - depletion
    if roll < 0
      nil
    else
      increment! :depletion
      opportunity_base.generate_event
    end
  end
end
