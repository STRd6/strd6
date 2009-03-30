class CreateAreaLinks < ActiveRecord::Migration
  def self.up
    create_table :area_links do |t|
      t.references :area, :null => false
      t.references :linked_area, :null => false

      t.text :requisites, :null => false, :default => [:any]

      t.timestamps :null => false
    end

    add_index :area_links, :area_id
  end

  def self.down
    drop_table :area_links
  end
end
