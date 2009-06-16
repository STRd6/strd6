class SiteController < ApplicationController
  caches_page :about
  before_filter :load_quiz, :only => [:index, :show, :about]
  
  def about
    
  end
  
  private
  
  def load_quiz
    @quiz = Quiz.last
  end
end
