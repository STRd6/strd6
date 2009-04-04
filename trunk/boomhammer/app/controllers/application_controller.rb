# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include TheAuthenticator
  
  helper :all # include all helpers, all the time
  helper :facility

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :current_character

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  protected

  def character_required
    current_character || redirect_to(:controller => 'characters')
  end

  def current_character
    @current_character ||= character_from_session unless @current_character == false
  end

  def current_character=(character)
    session[:character_id] = character ? character.id : nil
    @current_character = character || false
  end

  # Attempt to load the character id stored in the session, but only if it
  # belongs to the current account.
  def character_from_session
    character = Character.find_by_id(session[:character_id]) if session[:character_id]

    if character && current_account
      self.current_character = character if current_account.id == character.account_id
    else
      session[:character_id] = nil
      self.current_character = false
    end
  end

  # Temporary workaround until a reliable way to add `has_many :characters` to `Account` is found
  def current_account_characters
    Character.for_account_id(current_account.id)
  end
end
