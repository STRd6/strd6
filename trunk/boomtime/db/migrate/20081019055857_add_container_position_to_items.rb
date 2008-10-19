class AddContainerPositionToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :container_position, :integer, :default => 0
  end

  def self.down
    remove_column :items, :container_position
  end
end
