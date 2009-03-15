class SessionsController < ApplicationController
  def new
  end

  def create
    open_id_authentication(params[:openid_url])
  end

  def destroy
    self.current_player = nil
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to :controller => 'main'
  end
  
  protected
  
  def open_id_authentication(openid_url)
    authenticate_with_open_id(
      openid_url, 
      :required => [:nickname, :email, :fullname]
    ) do |result, identity_url, registration|
      
      if result.successful?
        @player = Player.find_or_initialize_by_identity_url(identity_url)
        
        logger.info "registration => #{registration}"
        
        if @player.new_record?
          @player.nickname = registration['nickname']
          @player.email = registration['email']
          @player.save false
        end
        
        self.current_player = @player
        successful_login
      else
        failed_login result.message
      end
      
    end
  end
  
  def password_authentication(login, password)
    self.current_player = Player.authenticate(login, password)
    if logged_in?
      successful_login
    else
      failed_login
    end
  end
  
  def failed_login(message = "Authentication failed.")
    flash.now[:error] = message
    render :action => 'new'
  end
  
  def successful_login
    redirect_to :controller => 'games'
    flash[:notice] = "Logged in successfully"
  end
end
