class AddEditabilityToItemBase < ActiveRecord::Migration
  def self.up
    add_column :item_bases, :editability, :string, :null => false, :default => Editable::Editability.default_string
  end

  def self.down
    remove_column :item_bases, :editability
  end
end
