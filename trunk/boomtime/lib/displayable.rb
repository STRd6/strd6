# Include this in ActiveRecord models to gain access to the magic power of 
# being displayable on screen!
# 
module Displayable
  def self.included(base)
    base.send :has_one, :display_datum, :as => :displayable, :dependent => :destroy
    base.send :validates_presence_of, :display_datum
    base.send :before_validation, :ensure_display_datum
  end
  
  def css_id
    return "#{self.class.name.underscore}_#{id}"
  end
  
  def css_classes
    []
  end
  
  def js_params
    'null'
  end
  
  def web_image
    if display_datum.image
      file = display_datum.image
    else
      file = "default"
    end
    
    return "#{image_directory}#{file}"
  end
  
  def image_directory
    "#{self.class.name.underscore.pluralize}/"
  end
  
  def overlay_text
    false
  end
  
  def top
    display_datum.top
  end
  
  def top=(top)
    ensure_display_datum
    display_datum.top = top
  end
  
  def left
    display_datum.left
  end
  
  def left=(left)
    ensure_display_datum
    display_datum.left = left
  end
  
  def update_position(left, top)
    display_datum.left = left
    display_datum.top = top
    display_datum.save
  end
  
  private
  def ensure_display_datum
    self.display_datum = DisplayDatum.new if self.display_datum.blank?
  end
end
