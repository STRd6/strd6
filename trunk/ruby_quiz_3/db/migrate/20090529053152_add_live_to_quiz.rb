class AddLiveToQuiz < ActiveRecord::Migration
  def self.up
    add_column :quizzes, :live, :boolean, :default => false
  end

  def self.down
    remove_column :quizzes, :live
  end
end
