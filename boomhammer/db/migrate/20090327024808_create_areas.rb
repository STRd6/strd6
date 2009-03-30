class CreateAreas < ActiveRecord::Migration
  def self.up
    create_table :areas do |t|
      t.references :area_base
      t.string :name
      t.boolean :starting_location, :null => false, :default => false

      t.timestamps :null => false
    end
  end

  def self.down
    drop_table :areas
  end
end
