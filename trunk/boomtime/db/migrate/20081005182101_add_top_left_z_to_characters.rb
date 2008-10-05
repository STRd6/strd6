class AddTopLeftZToCharacters < ActiveRecord::Migration
  def self.up
    add_column :characters, :top, :integer, :default => 0
    add_column :characters, :left, :integer, :default => 0
    add_column :characters, :z, :integer, :default => 0
  end

  def self.down
    remove_column :characters, :z
    remove_column :characters, :left
    remove_column :characters, :top
  end
end
