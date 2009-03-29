class Character < ActiveRecord::Base
  include Named

  belongs_to :account
  belongs_to :area

  has_many :items, :as => :owner, :dependent => :destroy

  validates_presence_of :area
  before_validation_on_create :assign_starting_area

  named_scope :for_account_id, lambda {|account_id| {:conditions => {:account_id => account_id}}}

  def take_opportunity(opportunity)
    transaction do
      if (item_base = opportunity.explore)
        items << item_base.spawn
      end
    end
  end

  def assign_starting_area
    self.area = Area.random.starting.first
  end
end
