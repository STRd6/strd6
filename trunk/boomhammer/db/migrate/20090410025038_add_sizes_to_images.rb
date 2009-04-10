class AddSizesToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :width, :integer, :null => false, :default => 32
    add_column :images, :height, :integer, :null => false, :default => 32
  end

  def self.down
    remove_column :images, :height
    remove_column :images, :width
  end
end
