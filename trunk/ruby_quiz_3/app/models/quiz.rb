class Quiz < ActiveRecord::Base
  has_many :responses
  named_scope :blank_summary, :conditions => {:summary => ""}, :order => "created_at DESC"
  named_scope :has_summary, :conditions => ["summary != \"\""], :order => "id DESC"
  
  before_save :set_summary_date

  def title_with_id
    "#{title} (##{id})"
  end
  
  def self.current_quiz
    self.blank_summary.first
  end
  
  def self.import(filename)
    File.open(filename) do |file|
      doc = Nokogiri::XML file
      num = 157
      (doc/"quiz").each do |quiz_element|
        summary = (quiz_element/"summary").text
        description = (quiz_element/"description").text
        
        quiz = Quiz.new(
          :title => num,
          :description => description,
          :summary => summary
        )
        
        (quiz_element/"solution").each do |solution|
          author = (solution/"author").text
          body = (solution/"text").text
          reference = (solution/"ruby_talk_reference").text
          
          quiz.responses.build(
            :author => author,
            :body => body,
            :reference => reference
          )
        end
        
        quiz.id = num
        quiz.save
        
        num += 1
      end
    end
  end
  
  private
  
  def set_summary_date
    unless self.summary.blank?
      self.summary_date ||= Time.now
    end
  end
end
