# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '801800efcb84723c7f4ef48cf8aa607a'
  
  filter_parameter_logging :password

  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  session :session_key => '_ruby_quiz_3_session'
  include AuthenticatedSystem
  # private
  # 
  # def authenticate
  #   authenticate_or_request_with_http_basic do |user_name, password|
  #     user_name == USER_NAME && password == PASSWORD
  #   end
  # end
end
