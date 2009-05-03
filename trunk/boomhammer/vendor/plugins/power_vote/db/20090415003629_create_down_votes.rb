class CreateDownVotes < ActiveRecord::Migration
  def self.up
    create_table :down_votes do |t|
      t.references :votable, :null => false
      t.string :votable_type, :null => false
      t.references :account, :null => false
      t.boolean :converted, :null => false, :default => false

      t.timestamps :null => false
    end

    add_index :down_votes, [:account_id, :votable_id, :votable_type], :unique => true
    add_index :down_votes, [:votable_id, :votable_type]

    add_column :images, :down_votes_count, :integer, :default => 0, :null => false
  end

  def self.down
    drop_table :down_votes
  end
end
