class EventBase < ActiveRecord::Base
  module EventType
    NONE = "none"
    SHOP = "shop"

    ALL = [NONE, SHOP]
  end

  include EventType
  include Named

  belongs_to :image

  validates_inclusion_of :event_type, :in => ALL

  def perform(character, params)
    case event_type
    when SHOP
      create_shop(character, params)
    else
      raise "Unknown event type: #{event_type}"
    end
  end

  def create_shop(character, params)
    currency = ItemBase.find(params[:currency])
    shop = Shop.create(:character => character, :area => character.area, :currency => currency)
    
    character.add_knowledge shop

    return shop
  end
end
