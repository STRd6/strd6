class RemoveOldDisplayAttributesFromModels < ActiveRecord::Migration
  def self.up
    remove_column :characters, :top, :left, :z, :image
    remove_column :features, :top, :left, :z, :image
    remove_column :items, :image
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Lazy Developer"
  end
end
