class WelcomeController < ApplicationController
  def index
    
  end
  
  def ui_test
    @title = "A Fabulous UI Test!"
    flash[:notice] = "The world's best notice"
    flash[:error] = "A terrifying error!!"
    
    @user = User.first
    @user.errors.add "A really uncool error"
  end
end
