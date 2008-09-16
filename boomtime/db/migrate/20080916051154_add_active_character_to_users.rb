class AddActiveCharacterToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :active_character_id, :integer
  end

  def self.down
    remove_column :users, :active_character_id
  end
end
