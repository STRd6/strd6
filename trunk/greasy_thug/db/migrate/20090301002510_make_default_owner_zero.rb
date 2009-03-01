class MakeDefaultOwnerZero < ActiveRecord::Migration
  def self.up
    execute "UPDATE annotations SET owner_id = 0 WHERE owner_id IS NULL"
    
    change_column :annotations, :owner_id, :integer, :null => false, :default => 0
  end

  def self.down
    change_column :annotations, :owner_id, :integer
  end
end
