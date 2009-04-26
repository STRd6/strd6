class AddLoginMetricsToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :last_login, :datetime
    add_column :accounts, :total_logins, :integer, :null => false, :default => 0

    Account.reset_column_information

    Account.all.each do |account|
      account.last_login = account.created_at
      account.save!
    end

    change_column :accounts, :last_login, :datetime, :null => false
  end

  def self.down
    remove_column :accounts, :total_logins
    remove_column :accounts, :last_login
  end
end
