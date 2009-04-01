class Badge < ActiveRecord::Base
  include Named

  belongs_to :badge_base
  belongs_to :owner, :polymorphic => true

  validates_presence_of :badge_base, :owner, :quantity
  validates_numericality_of :quantity

  delegate :name, :to => :badge_base
  delegate :image_file_name, :to => :badge_base

  named_scope :for_account_id, lambda {|account_id| {:conditions => {:owner_id => account_id, :owner_type => 'Account'}}}
end
