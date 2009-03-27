class CreateRecipeComponents < ActiveRecord::Migration
  def self.up
    create_table :recipe_components do |t|
      t.references :recipe, :null => false
      t.references :item_base, :null => false

      t.timestamps :null => false
    end
  end

  def self.down
    drop_table :recipe_components
  end
end
