class Feature < ActiveRecord::Base
  belongs_to :area
  
  def update_position(left, top)
    self.left = left.to_i
    self.top = top.to_i
    save
  end
  
  def overlay_text
    false
  end
end
