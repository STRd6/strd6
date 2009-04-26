class AddEnergyToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :energy, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :accounts, :energy
  end
end
