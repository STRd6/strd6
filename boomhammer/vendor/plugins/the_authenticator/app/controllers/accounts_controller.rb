class AccountsController < ApplicationController
  unloadable

  def show
    @title = "Your Account"
    @account = current_account
  end

  def edit
    @title = "Edit Account"
    @account = current_account
  end

  def update
    if current_account.update_attributes params[:account]
      flash[:notice] = "Account updated"
      redirect_to current_account
    else
      flash[:error] = "There was an error updating your account"
      @account = current_account
      render :action => :edit
    end
  end

  def activate
    logout_keeping_session!
    code = params[:activation_code]

    account = Account.find_by_activation_code(code) unless code.blank?

    case
    when (!code.blank?) && account && !account.active?
      account.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when code.blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a account with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
end
