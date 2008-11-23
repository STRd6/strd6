class CreateAbilities < ActiveRecord::Migration
  def self.up
    create_table :abilities do |t|
      t.string :name
      t.text :cost
      t.string :target_type

      t.timestamps
    end
  end

  def self.down
    drop_table :abilities
  end
end
