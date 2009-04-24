xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title("Ruby Quiz")
    xml.link("http://rubyquiz.strd6.com/")
    xml.description("Ruby Quiz is a weekly programming challenge for Ruby programmers in the spirit of the Perl Quiz of the Week. A new Ruby Quiz is sent to the Ruby Talk mailing list each Friday. (Watch for the [QUIZ] subject identifier.)")
    xml.language('en-us')
      for quiz in @quizzes
        if quiz.summary.blank?
          xml.item do
            xml.title(quiz.title_with_id)
            xml.description(Maruku.new(quiz.description).to_html)
            xml.author(quiz.author)
            xml.pubDate(quiz.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
            xml.link(quiz_path(quiz))
            xml.guid(quiz_path(quiz))
          end
        else
          xml.item do
            xml.title(quiz.title_with_id + " [Summary]")
            xml.description(Maruku.new(quiz.summary).to_html)
            xml.author(quiz.author)
            xml.pubDate(quiz.summary_date.strftime("%a, %d %b %Y %H:%M:%S %z"))
            xml.link(quiz_path(quiz),"#summary")
            xml.guid(quiz_path(quiz),"#summary")
          end
          
          xml.item do
            xml.title(quiz.title_with_id)
            xml.description(Maruku.new(quiz.description).to_html)
            xml.author(quiz.author)
            xml.pubDate(quiz.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
            xml.link(quiz_path(quiz))
            xml.guid(quiz_path(quiz))
          end
        end
      end
  }
}