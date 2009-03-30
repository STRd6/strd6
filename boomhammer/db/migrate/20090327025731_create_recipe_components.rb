class CreateRecipeComponents < ActiveRecord::Migration
  def self.up
    create_table :recipe_components do |t|
      t.references :recipe, :null => false
      t.references :item_base, :null => false
      t.integer :quantity, :null => false, :default => 1

      t.timestamps :null => false
    end
  end

  def self.down
    drop_table :recipe_components
  end
end
