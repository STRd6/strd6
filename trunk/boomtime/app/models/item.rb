class Item < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  has_one :display_datum, :as => :displayable
  
  def description
    "Lorem ipsum dolor sit amet blaw blaw. +13 Fire Damage. -7 Ice Resistance. Great against werewolves!"
  end
  
  # VV Display Datum Party Bus VV #
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
  # ^^ Display Datum Party Bus ^^ #
end
