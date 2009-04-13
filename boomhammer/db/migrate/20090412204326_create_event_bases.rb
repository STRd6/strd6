class CreateEventBases < ActiveRecord::Migration
  def self.up
    create_table :event_bases do |t|
      t.string :name, :null => false
      t.references :image
      t.string :event_type, :null => false, :default => "none"

      t.timestamps :null => false
    end
  end

  def self.down
    drop_table :event_bases
  end
end
