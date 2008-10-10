class Feature < ActiveRecord::Base
  belongs_to :area
  
  # VV Display Datum Party Bus VV #
  def update_position(left, top)
    self.left = left.to_i
    self.top = top.to_i
    save
  end
  
  def image
    if img = super
      return "plants/#{img}"
    else
      return "plants/tree3"
    end
  end
  
  def overlay_text
    false
  end
  # ^^ Display Datum Party Bus ^^ #
end
