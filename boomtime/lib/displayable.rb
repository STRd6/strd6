# Include this in ActiveRecord models to gain access to the magic power of 
# being displayable on screen!
module Displayable
  def self.included(base)
    base.send :has_one, :display_datum, :as => :displayable
    base.send :validates_presence_of, :display_datum
    base.send :before_validation, :ensure_display_datum
  end
  
  def ensure_display_datum
    self.display_datum = DisplayDatum.create if self.display_datum.blank?
  end
  
  def image
    if display_datum.image
      file = display_datum.image
    else
      file = "default"
    end
    
    return "items/#{file}"
  end
  
  def overlay_text
    false
  end
  
  def top
    display_datum.top
  end
  
  def top=(top)
    display_datum.top = top
  end
  
  def left
    display_datum.left
  end
  
  def left=(left)
    display_datum.left = left
  end
  
  def update_position(left, top)
    display_datum.left = left
    display_datum.top = top
    display_datum.save
  end
end
