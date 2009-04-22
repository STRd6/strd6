class AddAuthorToQuizzes < ActiveRecord::Migration
  def self.up
    add_column :quizzes, :author, :string, :null => false, :default => ""

    Quiz.reset_column_information

    Quiz.find(Array(157..188)).each do |quiz|
      quiz.author = "Matthew Moss"
      quiz.save
    end

    Quiz.all(:conditions => "id > 188").each do |quiz|
      quiz.author = "Daniel Moore"
      quiz.save
    end
  end

  def self.down
    remove_column :quizzes, :author
  end
end
