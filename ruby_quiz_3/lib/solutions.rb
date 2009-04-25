#!/usr/bin/env ruby

require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'cgi'

class Solutions
  def initialize(quiz_num)
    @quiz_num = quiz_num
    @responses = []
  end
  
  def self.responses(quiz_num)
    
    quiz = Solutions.new(quiz_num)
    
    quiz.responses
  end

  def responses
    build_quiz_uri
    get_quiz_response_url
    build_responses
    
    return @responses
  end
  
  private
  def build_quiz_uri
    query = CGI::escape("subject:(+#{@quiz_num}) +quiz")

    base_url = "http://www.ruby-forum.com/search?query="
    uri_string = (base_url + query)
    @query_uri = URI.parse(uri_string)
  end

  def get_quiz_response_url
    doc = Hpricot(open(@query_uri))
    quiz_table = doc.at("table[@class='topics list]")
    quizzes = quiz_table.search("tr[@class$='new-posts ']")

    highest_replies = 0
    link = ""

    #find the quiz that has the right subject and has the most replies
    quizzes.each do |quiz|
      subject = quiz.at("td[@class='subject']/a").innerHTML
      quiz_subject = "#" + @quiz_num.to_s

      if(subject.include?(quiz_subject))
        replies = quiz.at("td[@class='replies']").innerHTML.to_i
        if(replies > highest_replies)
          highest_replies = replies
          link = quiz.at("td[@class='subject']/a")[:href]    
        end
      end
    end

    #trim the excess anchor
    response_path = link.gsub(/#.*$/, "")
    
    @response_url = @query_uri.scheme + "://" + @query_uri.host + response_path              
  end

  def build_responses
    doc = Hpricot(open(@response_url))

    response_elements = doc.search(".post")

    response_elements.inject([]) do |@responses, response|
      link = @response_url + response.search("div[@class='subject]").at("a")[:href]
      author = response.search("span[@class]='name'").text.split("(").first.strip

      @responses << {:link => link, :author => author}
    end

    #if the summary has been posted, we want to remove that too
    #it's difficult to know if we shouldremove that final response...
    if(@responses.length > 0)
      if(@responses.last[:author] == @responses.first[:author])
        @responses.pop
      end
    end

    #remove the first response (which is from the quizmaster)
    @responses.delete_at(0)
    
    @responses
  end
end
