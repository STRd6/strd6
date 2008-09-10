class AddFactionIdToCharacters < ActiveRecord::Migration
  def self.up
    add_column :characters, :faction_id, :integer
  end

  def self.down
    remove_column :characters, :faction_id
  end
end
