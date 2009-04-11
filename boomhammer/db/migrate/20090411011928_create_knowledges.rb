class CreateKnowledges < ActiveRecord::Migration
  def self.up
    create_table :knowledges do |t|
      t.references :character, :null => false
      t.references :object, :null => false
      t.string :object_type, :null => false

      t.timestamps :null => false
    end

    add_index :knowledges, [:character_id, :object_id, :object_type], :unique => true
  end

  def self.down
    drop_table :knowledges
  end
end
