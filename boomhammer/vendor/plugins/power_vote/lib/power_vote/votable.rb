module PowerVote
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

    def level
      up_rank - down_rank
    end

    def vote_up(account)
      up_votes.create!(:account => account)
      convert_up
    end

    def vote_down(account)
      down_votes.create!(:account => account)
      convert_down
    end

    def convert_up
      transaction do
        votes_to_next_up = 2**(up_rank + 1)
        if up_votes.unconverted.count >= votes_to_next_up
          up_votes.unconverted.all(:limit => votes_to_next_up).each(&:convert!)
          self.up_rank += 1
          save!
        end
      end
    end

    def convert_down
      transaction do
        votes_to_next_down = 2**(down_rank + 1)
        if down_votes.unconverted.count >= votes_to_next_down
          down_votes.unconverted.all(:limit => votes_to_next_down).each(&:convert!)
          self.down_rank += 1
          save!
        end
      end
    end
  end
end