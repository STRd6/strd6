class EventBase < ActiveRecord::Base
  module EventType
    NONE = "none"
    SHOP = "shop"
    RECIPE = "recipe"

    ALL = [NONE, SHOP, RECIPE]
  end

  include EventType
  include Named

  belongs_to :image

  validates_inclusion_of :event_type, :in => ALL

  def perform(character, params)
    case event_type
    when SHOP
      {:created => create_shop(character, params)}
    when RECIPE
      recipe_knowledge = character.add_knowledge(Recipe.random.first)
      {:discovered => recipe_knowledge.object}
    else
      raise "Unknown event type: #{event_type}"
    end
  end

  def create_shop(character, params)
    currency = ItemBase.find(params[:currency])
    shop = Shop.create(
      :character => character,
      :area => character.area,
      :currency => currency,
      :image_id => image_id
    )
    
    character.add_knowledge shop

    return shop
  end
end
