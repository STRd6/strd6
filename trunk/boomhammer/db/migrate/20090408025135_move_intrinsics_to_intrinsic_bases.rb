class MoveIntrinsicsToIntrinsicBases < ActiveRecord::Migration
  def self.up
    rename_table :intrinsics, :intrinsic_bases

    create_table :intrinsics do |t|
      t.references :intrinsic_base, :null => false
      t.references :owner, :null => false
      t.string :owner_type, :null => false

      t.timestamps :null => false
    end

    add_index :intrinsics, [:owner_id, :owner_type]
    add_index :intrinsics, [:intrinsic_base_id, :owner_id, :owner_type], :unique => true

    remove_column :characters, :intrinsics
    remove_column :item_bases, :granted_abilities
    remove_column :area_links, :requisites
    remove_column :opportunity_bases, :requisites
  end

  def self.down
    drop_table :intrinsics

    rename_table :intrinsic_bases, :intrinsics
  end
end
