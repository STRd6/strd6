class AddTopLeftToFeatures < ActiveRecord::Migration
  def self.up
    add_column :features, :top, :integer
    add_column :features, :left, :integer
    add_column :features, :z, :integer
  end

  def self.down
    remove_column :features, :left
    remove_column :features, :top
    remove_column :features, :z
  end
end
