class DownVote < ActiveRecord::Base
  include PowerVote::VoteCore

  # Move this into VoteCore when possible
  belongs_to :votable, :polymorphic => true, :counter_cache => true
end
