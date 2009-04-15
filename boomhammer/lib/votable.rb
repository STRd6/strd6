# Provides:
#   has_many :up_votes
#   has_many :down_votes
#   #vote_up
#   #vote_down
module Votable
  def self.included(model)
    model.class_eval do
      has_many :up_votes, :as => :votable, :dependent => :destroy
      has_many :down_votes, :as => :votable, :dependent => :destroy

      attr_readonly :up_votes_count
      attr_readonly :down_votes_count
    end
  end

  def vote_up(account)
    up_votes.create!(:account => account)
  end

  def vote_down(account)
    down_votes.create!(:account => account)
  end
end
