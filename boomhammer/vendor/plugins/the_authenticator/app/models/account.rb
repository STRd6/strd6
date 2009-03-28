class Account < ActiveRecord::Base
  has_many :logins, :dependent => :destroy
end
