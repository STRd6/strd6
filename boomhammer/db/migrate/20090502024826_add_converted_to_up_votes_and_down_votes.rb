class AddConvertedToUpVotesAndDownVotes < ActiveRecord::Migration
  def self.up
    add_column :down_votes, :converted, :boolean, :null => false, :default => 0
    add_column :up_votes, :converted, :boolean, :null => false, :default => 0
  end

  def self.down
    remove_column :up_votes, :converted
    remove_column :down_votes, :converted
  end
end
