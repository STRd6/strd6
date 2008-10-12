class AddEnergyToCharacters < ActiveRecord::Migration
  def self.up
    add_column :characters, :energy, :integer, :default => 0
  end

  def self.down
    remove_column :characters, :energy
  end
end
