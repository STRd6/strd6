class Account < ActiveRecord::Base
  unloadable

  include Authentication::ByCookieToken
  include Authentication::AccountBuddy

  belongs_to :referrer, :class_name => "Account"

  has_many :logins, :dependent => :destroy

  attr_accessible :nickname, :email, :referrer_code

  validates_numericality_of :total_logins, :only_integer => true
  validates_presence_of :last_login, :referral_code

  before_validation_on_create :set_last_login_time, :initialize_referral_code

  def to_s
    nickname || "No Name"
  end

  def track_login
    self.last_login = Time.now
    self.total_logins += 1
    save!
  end

  # Get the this account's referrer's referral code or nil if no referrer
  def referrer_code
    if referrer
      referrer.referral_code
    else
      nil
    end
  end

  # Sets the referrer to the one specified by code, won't change the referrer if
  # it has already been set.
  def referrer_code=(code)
    self.referrer ||= Account.find_by_referral_code(code)
  end

  protected
  def set_last_login_time
    self.last_login ||= Time.now
  end

  def initialize_referral_code
    self.referral_code ||= make_token
  end
end
