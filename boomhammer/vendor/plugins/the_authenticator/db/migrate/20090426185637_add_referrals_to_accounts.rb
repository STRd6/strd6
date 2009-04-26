class AddReferralsToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :referral_code, :string, :null => false
    add_column :accounts, :referrer_id, :integer
  end

  def self.down
    remove_column :accounts, :referrer_id
    remove_column :accounts, :referral_code
  end
end
