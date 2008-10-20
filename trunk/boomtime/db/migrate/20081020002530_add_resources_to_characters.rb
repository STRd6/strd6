class AddResourcesToCharacters < ActiveRecord::Migration
  def self.up
    add_column :characters, :resources, :text
    Character.reset_column_information
    Character.all.each do |c|
      c.send(:roll_resources)
      c.save
    end
  end

  def self.down
    remove_column :characters, :resources
  end
end
