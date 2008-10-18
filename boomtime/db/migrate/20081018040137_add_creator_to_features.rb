class AddCreatorToFeatures < ActiveRecord::Migration
  def self.up
    add_column :features, :creator_id, :integer
  end

  def self.down
    remove_column :features, :creator_id
  end
end
