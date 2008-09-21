class AddImageDescriptionToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :image, :string
    add_column :items, :description, :string
  end

  def self.down
    remove_column :items, :description
    remove_column :items, :image
  end
end
