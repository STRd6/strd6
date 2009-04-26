class AddReferralsToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :referral_code, :string
    add_column :accounts, :referrer_id, :integer

    Account.all.each do |account|
      account.send(:initialize_referral_code)
      account.save!
    end

    change_column :accounts, :referral_code, :string, :null => false
  end

  def self.down
    remove_column :accounts, :referrer_id
    remove_column :accounts, :referral_code
  end
end
