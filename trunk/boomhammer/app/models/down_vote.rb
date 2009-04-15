class DownVote < ActiveRecord::Base
  belongs_to :votable, :polymorphic => true, :counter_cache => true
  belongs_to :account

  validates_presence_of :account
  # Only one vote per account per votable
  validates_uniqueness_of :account_id, :scope => [:votable_id, :votable_type]
end
