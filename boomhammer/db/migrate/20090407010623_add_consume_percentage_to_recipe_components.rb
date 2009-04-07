class AddConsumePercentageToRecipeComponents < ActiveRecord::Migration
  def self.up
    add_column :recipe_components, :consume_percentage, :integer, :null => false, :default => 100
  end

  def self.down
    remove_column :recipe_components, :consume_percentage
  end
end
