class AddImagesToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :image_id, :integer
  end

  def self.down
    remove_column :shops, :image_id
  end
end
