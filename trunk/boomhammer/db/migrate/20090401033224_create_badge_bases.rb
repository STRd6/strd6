class CreateBadgeBases < ActiveRecord::Migration
  def self.up
    create_table :badge_bases do |t|
      t.string :name, :null => false
      t.string :description, :null => false
      t.string :image_file_name, :null => false

      t.timestamps :null => false
    end
  end

  def self.down
    drop_table :badge_bases
  end
end
