class Player < ActiveRecord::Base
  #validates_presence_of :name
  #validates_uniqueness_of :name
  
  def name
    nickname || "Noob#{id}"
  end
  
  def play
    "#{self} wants to play!"
  end
end
