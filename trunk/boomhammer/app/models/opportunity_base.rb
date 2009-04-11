class OpportunityBase < ActiveRecord::Base
  include Requisite
  include Eventful

  has_many :opportunities, :dependent => :destroy

  validates_presence_of :name

  def spawn(attributes={})
    opportunity = Opportunity.new(attributes)
    opportunities << opportunity
    return opportunity
  end
end
