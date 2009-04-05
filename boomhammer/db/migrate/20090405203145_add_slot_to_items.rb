class AddSlotToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :slot, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :items, :slot
  end
end
