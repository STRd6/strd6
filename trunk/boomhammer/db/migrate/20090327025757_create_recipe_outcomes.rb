class CreateRecipeOutcomes < ActiveRecord::Migration
  def self.up
    create_table :recipe_outcomes do |t|
      t.references :recipe, :null => false
      t.references :item_base, :null => false
      t.integer :weight, :null => false, :default => 1

      t.timestamps :null => false
    end

    add_index :recipe_outcomes, [:recipe_id, :weight]
  end

  def self.down
    drop_table :recipe_outcomes
  end
end
