class CreateAreaBases < ActiveRecord::Migration
  def self.up
    create_table :area_bases do |t|
      t.string :name, :null => false
      t.text :description, :null => false

      t.timestamps :null => false
    end
  end

  def self.down
    drop_table :area_bases
  end
end
