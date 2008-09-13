class Area < ActiveRecord::Base
  has_many :adjacencies
  has_many :adjacent_areas, :through => :adjacencies
end
