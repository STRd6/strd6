class UserMailer < ActionMailer::Base
  include ActionController::UrlWriter
  default_url_options[:host] = CONF[:host]
  
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = activate_url :activation_code => user.activation_code
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = home_url
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "strengthd6@gmail.com"
      @subject     = "[STRd6] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
