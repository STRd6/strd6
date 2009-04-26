class AddRegionIdToAreas < ActiveRecord::Migration
  def self.up
    add_column :areas, :region_id, :integer

    boomtown = Region.find_or_create_by_name "Boomtown"

    Area.reset_column_information

    Area.all.each do |area|
      area.region = boomtown
      area.save!
    end

    change_column :areas, :region_id, :integer, :null => false

    add_index :areas, :region_id
  end

  def self.down
    remove_column :areas, :region_id
  end
end
