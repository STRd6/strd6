class UpdateDisplayableToHaveNonNullColumns < ActiveRecord::Migration
  def self.up
    change_column :display_data, :top, :integer, :default => 0, :null => false
    change_column :display_data, :left, :integer, :default => 0, :null => false
    change_column :display_data, :z, :integer, :default => 0, :null => false
  end

  def self.down
    change_column :display_data, :top, :integer, :default => 0
    change_column :display_data, :left, :integer, :default => 0
    change_column :display_data, :z, :integer, :default => 0
  end
end
