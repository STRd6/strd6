class Faction < ActiveRecord::Base
  has_many :characters
  
  def channel
    :"faction_#{id}"
  end
end
