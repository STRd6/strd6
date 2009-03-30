class Character < ActiveRecord::Base
  include Named

  attr_accessor :intrinsic

  serialize :intrinsics

  belongs_to :account
  belongs_to :area

  has_many :items, :as => :owner, :dependent => :destroy

  validates_presence_of :area
  validates_numericality_of :actions, :greater_than_or_equal_to => 0

  before_validation_on_create :assign_starting_area, :set_default_intrinsics, :add_intrinsic

  named_scope :for_account_id, lambda {|account_id| {:conditions => {:account_id => account_id}}}

  def take_opportunity(opportunity)
    transaction do
      if actions > 0
        self.actions -= 1
        if (item_base = opportunity.explore)
          item = item_base.spawn
          items << item
          "Got #{item}"
        end
      else
        "No actions remaining"
      end
    end
  end

  def take_area_link(area_link)
    transaction do
      if actions > 0
        self.actions -= 1
        self.area = area_link.linked_area
        save!
        "Travelled to #{area}"
      else
        "No actions remaining"
      end
    end
  end

  def assign_starting_area
    self.area = Area.random.starting.first
  end
  
  def set_default_intrinsics
    self.intrinsics ||= {}
  end

  def add_intrinsic
    intrinsics[intrinsic.to_sym] = true if intrinsic
  end
end
