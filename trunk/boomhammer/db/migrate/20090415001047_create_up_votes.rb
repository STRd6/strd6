class CreateUpVotes < ActiveRecord::Migration
  def self.up
    create_table :up_votes do |t|
      t.references :votable, :null => false
      t.string :votable_type, :null => false
      t.references :account, :null => false

      t.timestamps :null => false
    end

    add_index :up_votes, [:account_id, :votable_id, :votable_type], :unique => true
    add_index :up_votes, [:votable_id, :votable_type]
    
    add_column :images, :up_votes_count, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :images, :up_votes_count

    drop_table :up_votes
  end
end
