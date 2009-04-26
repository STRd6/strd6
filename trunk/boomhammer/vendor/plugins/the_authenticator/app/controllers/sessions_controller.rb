# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  unloadable
  
  def new
    session[:referrer_code] = params[:referral_code]
  end

  def create
    open_id_authentication(params[:openid_url])
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
        login = Login.find_or_initialize_by_identity_url(identity_url)

        if login.new_record?
          login.account = Account.new(
            :nickname => registration['nickname'],
            :email => registration['email'],
            :referrer_code => session[:referrer_code]
          )
          login.save!
        end

        self.current_account = login.account
        current_account.track_login

        successful_login
      else
        failed_login result.message
      end
    end
  end

  def successful_login
    flash[:notice] = "Logged in successfully"

    new_cookie_flag = (params[:remember_me] == "1")
    handle_remember_cookie! new_cookie_flag

    redirect_back_or_default('/')
  end

  def failed_login(message)
    flash[:error] = message

    @login       = params[:login]
    @remember_me = params[:remember_me]

    render :action => 'new'
  end
end
