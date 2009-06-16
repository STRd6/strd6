class Admin::QuizzesController < ApplicationController
  include AuthenticatedSystem
  
  before_filter :login_required
  after_filter :remove_cache_files, :except => [ :show, :index ]
  
  def index
    @quizzes = Quiz.all_live :order => "id DESC" unless session[:user_id]
    @quizzes = Quiz.all :order => "id DESC"
  end
  
  def show
    if(params[:id])
      @quiz = Quiz.find(params[:id])
    else
      @quiz = Quiz.current_quiz
    end
  end
  
  def new
    @quiz = Quiz.new
  end
  
  def create
    @quiz = Quiz.new(params[:quiz])
    if @quiz.save
      flash[:notice] = "Successfully created quizzes."
      redirect_to admin_quiz_path(@quiz)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @quiz = Quiz.find(params[:id])
  end
  
  def update
    @quiz = Quiz.find(params[:id])
    if @quiz.update_attributes(params[:quiz])
      flash[:notice] = "Successfully updated quizzes."
      redirect_to admin_quiz_path(@quiz)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @quizzes = Quiz.find(params[:id])
    @quizzes.destroy
    flash[:notice] = "Successfully destroyed quizzes."
    redirect_to quizzes_url
  end
  
  private
  
  def remove_cache_files
    #TODO: We really should expire all pages here because the sidebar includes
    # all quizzes.
    logger.info "Removing Cache Files"
    Quiz.all.each do |quiz|
      expire_page(:controller => "/quizzes", :action => "show", :id => quiz.id)
    end
    
    expire_page formatted_quizzes_path(:controller => "/quizzes", :format => "rss")

    #Add any other static pages to expire here
    expire_page(:controller => "/site", :action => "about")
    expire_page(quizzes_path)
    expire_page(root_path)
  end
end
