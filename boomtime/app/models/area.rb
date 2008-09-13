class Area < ActiveRecord::Base
  has_many :adjacencies, :dependent => :destroy
  has_many :adjacent_areas, :through => :adjacencies
  
  has_many :characters
end
