class AddImageIdToCharacters < ActiveRecord::Migration
  def self.up
    add_column :characters, :image_id, :integer
  end

  def self.down
    remove_column :characters, :image_id
  end
end
