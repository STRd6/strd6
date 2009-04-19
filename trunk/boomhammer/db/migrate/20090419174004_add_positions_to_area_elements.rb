class AddPositionsToAreaElements < ActiveRecord::Migration
  def self.up
    add_column :opportunities, :top, :integer, :null => false, :default => 0
    add_column :opportunities, :left, :integer, :null => false, :default => 0
    add_column :shops, :top, :integer, :null => false, :default => 0
    add_column :shops, :left, :integer, :null => false, :default => 0
    add_column :characters, :top, :integer, :null => false, :default => 0
    add_column :characters, :left, :integer, :null => false, :default => 0
    add_column :items, :top, :integer, :null => false, :default => 0
    add_column :items, :left, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :items, :left
    remove_column :items, :top
    remove_column :characters, :left
    remove_column :characters, :top
    remove_column :shops, :left
    remove_column :shops, :top
    remove_column :opportunities, :left
    remove_column :opportunities, :top
  end
end
