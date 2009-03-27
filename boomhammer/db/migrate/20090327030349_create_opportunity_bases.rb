class CreateOpportunityBases < ActiveRecord::Migration
  def self.up
    create_table :opportunity_bases do |t|
      t.string :name, :null => false
      t.text :description, :null => false

      t.timestamps :null => false
    end
  end

  def self.down
    drop_table :opportunity_bases
  end
end
