# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Messenger
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '01af6afa7f8f56bfa759ae004d49b701'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  helper_method :slot_class, :current_player, :channels
  
  before_filter :add_default_channels
  
  protected
  def game_state_error(message)
    {:text => message || "I am a teapot", :status => 418}
  end
  
  def slot_class
    Slot::DISPLAY_CLASS
  end
  
  def add_default_channels
    add_channel_for current_player
  end
  
  def current_player=(player)
    if player
      if (session[:player_id] = player.id)
        @current_player = player
      else
        @current_player = nil
      end
    else
      @current_player = nil
    end
  end
  
  def current_player
    @current_player ||= (player_from_session) unless @current_player == false
  end
  
  def player_from_session
    if session[:player_id]
      begin
        @current_player = Player.find(session[:player_id])
      rescue ActiveRecord::RecordNotFound
        session[:player_id] = false
      end
    else
      false
    end
  end
end
