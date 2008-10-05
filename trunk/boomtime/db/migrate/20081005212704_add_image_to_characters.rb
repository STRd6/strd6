class AddImageToCharacters < ActiveRecord::Migration
  def self.up
    add_column :characters, :image, :string
  end

  def self.down
    remove_column :characters, :image
  end
end
