class CreateOpportunities < ActiveRecord::Migration
  def self.up
    create_table :opportunities do |t|
      t.references :opportunity_base, :null => false
      t.references :area, :null => false

      t.timestamps :null => false
    end

    add_index :opportunities, :area_id
  end

  def self.down
    drop_table :opportunities
  end
end
