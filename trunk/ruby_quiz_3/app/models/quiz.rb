class Quiz < ActiveRecord::Base
  has_many :responses
  
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
        
        quiz.save
        
        num += 1
      end
    end
  end
end
