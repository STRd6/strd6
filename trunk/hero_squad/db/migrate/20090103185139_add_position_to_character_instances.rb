class AddPositionToCharacterInstances < ActiveRecord::Migration
  def self.up
    add_column :character_instances, :x, :integer
    add_column :character_instances, :y, :integer
  end

  def self.down
    remove_column :character_instances, :y
    remove_column :character_instances, :x
  end
end
