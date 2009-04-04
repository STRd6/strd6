class CreateIntrinsics < ActiveRecord::Migration
  def self.up
    create_table :intrinsics do |t|
      t.string :name, :null => false
      t.references :image

      t.timestamps :null => false
    end

    add_index :intrinsics, :name, :unique => true

    # Stringify the old symbol based requisites
    OpportunityBase.all.each do |o|
      o.requisites.map!(&:to_s)
      o.save!
    end

    AreaLink.all.each do |a|
      a.requisites.map!(&:to_s)
      a.save!
    end
  end

  def self.down
    drop_table :intrinsics
  end
end
