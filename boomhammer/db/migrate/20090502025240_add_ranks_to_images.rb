class AddRanksToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :up_rank, :integer, :default => 0, :null => false
    add_column :images, :down_rank, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :images, :down_rank
    remove_column :images, :up_rank
  end
end
