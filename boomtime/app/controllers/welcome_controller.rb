class WelcomeController < ApplicationController
  before_filter :login_required, :only => [:game]
  
  def index
    
  end
  
  def ui_test
    @title = "A Fabulous UI Test!"
    flash[:notice] = "The world's best notice"
    flash[:error] = "A terrifying error!!"
    
    @user = User.first
    @user.errors.add "A really uncool error"
  end
  
  def chat
  end
  
  def send_data
    render :juggernaut do |page|
      page.call :add_chat, "<b>#{current_user}:</b> #{h params[:chat_input]}"      
    end
    render :nothing => true
  end

end
