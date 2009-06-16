class AddAuthorToQuizzes < ActiveRecord::Migration
  def self.up
    add_column :quizzes, :author, :string, :null => false, :default => ""

    Quiz.reset_column_information

    begin
      Quiz.find(Array(157..188)).each do |quiz|
        quiz.author = "Matthew Moss"
        quiz.save
      end
    rescue
      print "An error occurred: ",$!, "\n"
    end
    
    begin
      Quiz.all(:conditions => "id > 188").each do |quiz|
        quiz.author = "Daniel Moore"
        quiz.save
      end
    rescue
      print "An error occurred: ",$!, "\n"
    end
  end

  def self.down
    remove_column :quizzes, :author
  end
end
