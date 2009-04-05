class AddGrantedAbilitiesToItemBases < ActiveRecord::Migration
  def self.up
    add_column :item_bases, :granted_abilities, :text

    ItemBase.reset_column_information

    ItemBase.all.each do |item_base|
      item_base.granted_abilities = []
      item_base.save!
    end

    change_column :item_bases, :granted_abilities, :text, :null => false
  end

  def self.down
    remove_column :item_bases, :granted_abilities
  end
end
