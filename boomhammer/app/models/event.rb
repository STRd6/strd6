class Event < ActiveRecord::Base
  include Named

  belongs_to :base, :polymorphic => true
  belongs_to :owner, :polymorphic => true

  #has_one :image, :through => :base

  validates_presence_of :base, :owner
  validates_numericality_of :weight, :greater_than => 0

  delegate :name, :image,
    :to => :base

  def perform(character, params={})
    case base_type
    when "AreaBase"
      {:created => construct_area(character)}
    when "ItemBase"
      {:got => [character.add_item_from_base(base)]}
    when "OpportunityBase"
      character.area.add_opportunity(:opportunity_base => base)
      # HAX Kind of a hack
      opportunity = character.area.opportunities.last
      character.add_knowledge opportunity
      
      {:created => opportunity}
    when "EventBase"
      # Delegating special events here
      base.perform(character, params)
    else
      raise "Unable to perform event. Unknown base type: #{base_type}"
    end
  end

  def shop_event?
    base_type == "EventBase" && base.event_type == EventBase::EventType::SHOP
  end

  protected

  def construct_area(character)
    house = Area.create!(
      :name => "#{character.name}'s #{base}",
      :area_base => base
    )

    house.add_bi_directional_link_to character.area

    # Gain knowledge of the new dealies
    # HAX Kind of a hack
    new_link = character.area.area_links.last
    character.add_knowledge new_link
    character.add_knowledge house

    house.area_links.each do |link|
      character.add_knowledge link
    end

    return house
  end
end
