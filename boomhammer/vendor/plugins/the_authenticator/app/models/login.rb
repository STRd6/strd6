class Login < ActiveRecord::Base
  belongs_to :account

  validates_associated :account

  validates_presence_of :identity_url
  validates_uniqueness_of :identity_url
end
