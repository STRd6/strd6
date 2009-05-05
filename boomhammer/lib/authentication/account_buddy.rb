module Authentication
  module AccountBuddy
    def self.included(account)
      account.class_eval do
        has_many :characters
        has_many :referrals, :class_name => "Account", :foreign_key => "referrer_id"
      end
    end

    def add_offense
      increment! :offenses
    end
  end
end
