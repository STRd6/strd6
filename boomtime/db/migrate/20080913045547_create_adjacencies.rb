class CreateAdjacencies < ActiveRecord::Migration
  def self.up
    create_table :adjacencies do |t|
      t.references :area
      t.references :adjacent_area

      t.timestamps
    end
  end

  def self.down
    drop_table :adjacencies
  end
end
