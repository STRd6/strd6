class Area < ActiveRecord::Base
  has_many :adjacencies, :dependent => :destroy
  has_many :adjacent_areas, :through => :adjacencies
  
  has_many :characters
  has_many :features
  has_many :signs
  has_many :items, :as => :owner
  
  def displayables
    characters + features + signs + items
  end
  
  def channel
    :"area_#{id}"
  end
end
