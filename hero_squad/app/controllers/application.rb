# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '01af6afa7f8f56bfa759ae004d49b701'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  helper_method :slot_class
  
  def game_state_error
    {:text => "I am a teapot", :status => 418}
  end
  
  def slot_class
    Slot::DISPLAY_CLASS
  end
end
