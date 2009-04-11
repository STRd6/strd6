class AddImagesToAreaBasesAndOpportunityBases < ActiveRecord::Migration
  def self.up
    add_column :area_bases, :image_id, :integer
    add_column :opportunity_bases, :image_id, :integer
  end

  def self.down
    remove_column :opportunity_bases, :image_id
    remove_column :area_bases, :image_id
  end
end
