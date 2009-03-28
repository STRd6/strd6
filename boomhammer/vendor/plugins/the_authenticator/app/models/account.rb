class Account < ActiveRecord::Base
  include Authentication::ByCookieToken

  has_many :logins, :dependent => :destroy
end
