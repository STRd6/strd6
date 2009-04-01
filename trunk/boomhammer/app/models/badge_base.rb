class BadgeBase < ActiveRecord::Base
  include Named

  has_many :badges, :dependent => :destroy

  validates_presence_of :name, :description, :image_file_name

  def grant(account)
    if existing = Badge.for_account_id(account.id).first
      existing.increment!(:quantity)
      return existing
    else
      badge = Badge.new(:owner => account, :badge_base => self)
      badges << badge
      return badge
    end
  end
end
