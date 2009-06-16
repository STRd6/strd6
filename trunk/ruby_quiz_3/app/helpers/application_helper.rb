# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def quiz_link(quiz)
    if(quiz.live)
      link_to quiz.title, quiz
    else
      link_to "#{quiz.title}(unposted)", quiz, {:class => "unposted"}
    end
  end
  
  def admin_quiz_link(quiz)
    if(quiz.live)
      link_to quiz.title, quiz
    else
      link_to "#{quiz.title}(unposted)", admin_quiz_path(quiz), {:class => "unposted"}
    end
  end
end
