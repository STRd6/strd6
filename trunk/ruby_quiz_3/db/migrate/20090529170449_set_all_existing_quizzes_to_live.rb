class SetAllExistingQuizzesToLive < ActiveRecord::Migration
  def self.up
    Quiz.update_all(:live => true)
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
