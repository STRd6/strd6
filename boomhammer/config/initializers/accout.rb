class Account < ActiveRecord::Base
  has_many :characters, :dependent => :destroy
end