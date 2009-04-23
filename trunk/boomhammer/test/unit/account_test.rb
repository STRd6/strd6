require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  context "New account by login" do
    should "create a new account" do
      login = Login.new :identity_url => "example.com"
      login.account = Account.new

      login.save!
    end
  end
end
