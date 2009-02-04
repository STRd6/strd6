class CreateQuizzes < ActiveRecord::Migration
  def self.up
    create_table :quizzes do |t|
      t.string :title
      t.text :description
      t.text :summary
      t.date :posted

      t.timestamps
    end
  end

  def self.down
    drop_table :quizzes
  end
end
