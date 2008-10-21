class AddPropertiesToFeatures < ActiveRecord::Migration
  def self.up
    add_column :features, :properties, :text
  end

  def self.down
    remove_column :features, :properties
  end
end
