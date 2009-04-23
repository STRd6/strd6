class Account < ActiveRecord::Base
  include Authentication::ByCookieToken

  has_many :logins, :dependent => :destroy

  attr_accessible :nickname, :email

  validates_numericality_of :total_logins, :only_integer => true
  validates_presence_of :last_login

  before_create :set_last_login_time

  def to_s
    nickname || "No Name"
  end

  def track_login
    self.last_login = Time.now
    self.total_logins += 1
    save!
  end

  protected
  def set_last_login_time
    self.last_login = Time.now
  end
end
