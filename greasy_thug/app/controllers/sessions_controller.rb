# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # render new.rhtml
  def new
  end

  def create
    if using_open_id?
      open_id_authentication(params[:openid_url])
    else
      password_authentication(params[:login], params[:password])
    end
      
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  def open_id_authentication(openid_url)
    authenticate_with_open_id(openid_url, :required => [:nickname, :email]) do |result, identity_url, registration|
      if result.successful?
        user = User.find_or_initialize_by_identity_url(identity_url)
        if user.new_record?
          user.login = registration['nickname']
          user.email = registration['email']
          user.save(false)
        end
        self.current_user = user
        successful_login
      else
        failed_login result.message
      end
    end
  end
  
  def password_authentication(login, password)
    logout_keeping_session!
    user = User.authenticate(login, password)
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      successful_login
    else
      failed_login "Couldn't log you in as '#{params[:login]}'"
    end
  end
  
  def successful_login
    new_cookie_flag = (params[:remember_me] == "1")
    handle_remember_cookie! new_cookie_flag
    redirect_back_or_default('/')
    flash[:notice] = "Logged in successfully"
  end
  
  def failed_login(message)
    note_failed_signin(message)
    @login       = params[:login]
    @remember_me = params[:remember_me]
    render :action => 'new'
  end
  
  # Track failed login attempts
  def note_failed_signin(message)
    flash[:error] = message
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
