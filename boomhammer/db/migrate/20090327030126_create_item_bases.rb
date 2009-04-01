class CreateItemBases < ActiveRecord::Migration
  def self.up
    create_table :item_bases do |t|
      t.string :name, :null => false
      t.text :description, :null => false
      t.references :image

      t.timestamps :null => false
    end
  end

  def self.down
    drop_table :item_bases
  end
end
