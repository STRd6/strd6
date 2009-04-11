class Event < ActiveRecord::Base
  include Named

  belongs_to :base, :polymorphic => true
  belongs_to :owner, :polymorphic => true

  #has_one :image, :through => :base

  validates_presence_of :base
  validates_numericality_of :weight, :greater_than => 0

  delegate :name, :image,
    :to => :base

  delegate :name, :to => :base

  def perform(character)
    case base_type
    when "AreaBase"
      construct_home(character)
    when "ItemBase"
      character.add_item_from_base(base)
    when "OpportunityBase"
      character.area.add_opportunity(:opportunity_base => base)
    else
      raise "Unable to perform event. Unknown base type: #{base_type}"
    end
  end

  def construct_home(character)
    house = Area.create!(
      :name => "#{character.name}'s House",
      :area_base => base
    )

    house.add_bi_directional_link_to character.area
  end
end
