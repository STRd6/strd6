class Account < ActiveRecord::Base
  include Authentication::ByCookieToken

  has_many :logins, :dependent => :destroy

  attr_accessible :nickname, :email
end
