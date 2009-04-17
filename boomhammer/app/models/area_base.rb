class AreaBase < ActiveRecord::Base
  include Named

  belongs_to :account
  belongs_to :image

  has_many :areas, :dependent => :destroy

  def spawn(attributes={})
    area = Area.new(attributes)
    areas << area
    return area
  end
end
