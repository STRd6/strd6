class AddCreatorToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :creator_id, :integer
  end

  def self.down
    remove_column :items, :creator_id
  end
end
