class Item < ActiveRecord::Base
  include Displayable
  include Propertied
  
  belongs_to :owner, :polymorphic => true
  belongs_to :creator, :class_name => 'Character'
  validates_presence_of :container_position
  
  alias_method :area, :owner
  alias_method :"area=", :"owner="
  
  def proteus
    {
      :wood_pile => {
        :pile => {:wood => 1},
        :image => 'wood_pile'
      },
      :axe => {
        :image => 'axe',
        :ability => 'chop',
      }
    }
  end
  
  def description
    "Lorem ipsum dolor sit amet blaw blaw. +13 Fire Damage. -7 Ice Resistance. Great against werewolves!"
  end
  
  def css_classes
    classes = []
    classes << 'pile' if properties[:pile]
    classes << 'equipable' if properties[:ability]
    return classes
  end
  
  def js_params
    return "'#{properties[:ability]}'" if properties[:ability]
    return super
  end
end
