# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# Load secret email settings
begin
  require "#{RAILS_ROOT}/config/email.rb"
  require "#{RAILS_ROOT}/config/site_keys.rb"

  ActionMailer::Base.smtp_settings = {
    :tls => true,
    :address => "smtp.gmail.com",
    :port => "587",
    :domain => "strd6.com",
    :authentication => :plain,
    :user_name => SMTP_USER_NAME,
    :password => SMTP_PASSWORD
  }
rescue
  # No email for you!
end

CONF[:host] = '127.0.0.1:3000'