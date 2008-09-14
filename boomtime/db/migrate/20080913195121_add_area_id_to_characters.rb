class AddAreaIdToCharacters < ActiveRecord::Migration
  def self.up
    add_column :characters, :area_id, :integer
  end

  def self.down
    remove_column :characters, :area_id
  end
end
