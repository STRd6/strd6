class SiteController < ApplicationController
  caches_page :about
  after_filter :expire_cache, :except => [:show, :index, :about]
  before_filter :load_quiz, :only => [:index, :show, :about]
  
  def about
    
  end
  
  private
  
  def load_quiz
    @quiz = Quiz.last
  end
  
  def expire_cache
    expire_page :action => "about"
  end
end
