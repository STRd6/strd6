class AddSummaryDateToQuiz < ActiveRecord::Migration
  def self.up
    add_column :quizzes, :summary_date, :datetime

    Quiz.reset_column_information
    
    #assign a summary_date based on updated_at if summary is not blank
    Quiz.find(:all).each do |quiz|
      unless quiz.summary.blank?
        quiz.summary_date = quiz.updated_at
        quiz.save!
      end
    end
  end

  def self.down
    remove_column :quizzes, :summary_date
  end
end
