# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include WindowPimp
  
  helper :all # include all helpers, all the time
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '092f8ea65f75723641cd47fbcb74608d'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password
  
#  def window_style(window)
#    return "" unless current_user
#    
#    w = WindowPosition.style_for(current_user.id, window)
#
#    return "" unless w
#    
#    "top: #{w.top}px; left: #{w.left}px;"
#  end
#  
#  helper_method :window_style
  
end
