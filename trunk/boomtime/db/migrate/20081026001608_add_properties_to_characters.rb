class AddPropertiesToCharacters < ActiveRecord::Migration
  def self.up
    add_column :characters, :properties, :text
    Character.reset_column_information
    Character.all.each do |c|
      c.send(:initialize_properties)
      c.save
    end
  end

  def self.down
    remove_column :characters, :properties
  end
end
