class Character < ActiveRecord::Base
  include Displayable
  include Propertied
  
  belongs_to :owner, :class_name => 'User'
  belongs_to :faction
  belongs_to :area
  
  has_many :inventory_items, :as => :owner, :class_name => 'Item', :order => 'container_position'
  
  validates_length_of :name, :within => 2..32, :too_long => "pick a shorter name", :too_short => "pick a longer name"
  
  serialize :stats
  serialize :resources
  
  before_create :roll_stats, :roll_resources, :set_area
  
  Proteus = {}
  
  def stat_keys
    [:str, :dex, :pow]
  end
  
  def resource_keys
    [:seeds, :wood, :food, :stone, :copper, :silver]
  end
  
  def bonus
    {:str => 0, :dex => 0, :pow => 0}
  end
  
  def inventory
    return self.inventory_items
  end
  
  def overlay_text
    name
  end
  
  def pay(costs)
    # TODO: Lock model?
    costs.each do |key, value|
      if resources[key] < value
        return false
      end
    end
    
    costs.each do |key, value|
      resources[key] -= value
    end
    save
  end

  private
  def roll_stats
    self.stats = {:str => 3 + rand(5), :dex => 3 + rand(5), :pow => 3 + rand(5)}
  end
  
  def roll_resources
    self.resources = {
      :seeds => 1 + rand(6), 
      :wood => 1 + rand(6),
      :food => 1 + rand(6),
      :stone => 1 + rand(6),
      :copper => 2 + rand(6) + rand(6),
      :silver => 1 + rand(6),
    }
  end
  
  def set_area
    self.area_id = 1
  end
end
