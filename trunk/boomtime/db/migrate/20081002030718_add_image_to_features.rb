class AddImageToFeatures < ActiveRecord::Migration
  def self.up
    add_column :features, :image, :string
  end

  def self.down
    remove_column :features, :image
  end
end
