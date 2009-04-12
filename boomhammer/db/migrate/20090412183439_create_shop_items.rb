class CreateShopItems < ActiveRecord::Migration
  def self.up
    create_table :shop_items do |t|
      t.integer :price, :null => false
      t.references :shop, :null => false
      t.references :item, :null => false

      t.timestamps :null => false
    end

    add_index :shop_items, :shop_id
  end

  def self.down
    drop_table :shop_items
  end
end
