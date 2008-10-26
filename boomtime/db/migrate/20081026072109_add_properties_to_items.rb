class AddPropertiesToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :properties, :text
    Item.reset_column_information
    Item.all.each do |i|
      i.send(:initialize_properties)
      i.save
    end
  end

  def self.down
    remove_column :items, :properties
  end
end
