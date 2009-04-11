class OpportunityBase < ActiveRecord::Base
  include Named
  include Requisite
  include Eventful

  belongs_to :image

  has_many :opportunities, :dependent => :destroy

  def spawn(attributes={})
    opportunity = Opportunity.new(attributes)
    opportunities << opportunity
    return opportunity
  end
end
