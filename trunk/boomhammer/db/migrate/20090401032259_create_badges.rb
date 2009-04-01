class CreateBadges < ActiveRecord::Migration
  def self.up
    create_table :badges do |t|
      t.references :owner, :null => false
      t.string :owner_type, :null => false
      t.references :badge_base, :null => false
      t.integer :quantity, :null => false, :default => 1

      t.timestamps :null => false
    end

    add_index :badges, [:owner_id, :owner_type]
  end

  def self.down
    drop_table :badges
  end
end
