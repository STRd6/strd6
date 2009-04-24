module Authentication
  module AccountBuddy
    def self.included(account)
      account.class_eval do
        has_many :characters
      end
    end
  end
end
