class AddOffensesToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :offenses, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :accounts, :offenses
  end
end
