class AreaBase < ActiveRecord::Base
  has_many :areas, :dependent => :destroy

  def spawn(attributes={})
    area = Area.new(attributes)
    areas << area
    return area
  end
end
