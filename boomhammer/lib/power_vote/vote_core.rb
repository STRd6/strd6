module PowerVote
  module VoteCore
    def self.included(vote_model)
      vote_model.class_eval do
        include InstanceMethods
        belongs_to :account

        validates_presence_of :account
        # Only one vote per account per votable
        validates_uniqueness_of :account_id, :scope => [:votable_id, :votable_type]

        named_scope :unconverted, :conditions => {:converted => false}
      end
    end

    module InstanceMethods
      def convert!
        update_attribute(:converted, true)
      end
    end
  end
end
