class Character < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  belongs_to :faction
  belongs_to :area
  
  has_many :inventory_items, :as => :owner, :class_name => 'Item'
  
  validates_length_of :name, :within => 2..32, :too_long => "pick a shorter name", :too_short => "pick a longer name"
  
  serialize :stats
  
  before_create :roll_stats, :set_area

  def roll_stats
    str = 3 + rand(5)
    dex = 3 + rand(5)
    pow = 3 + rand(5)
    
    self.stats = {:str => str, :dex => dex, :pow => pow}
  end
  
  def set_area
    self.area_id = 1
  end
  
  def stat_keys
    [:str, :dex, :pow]
  end
  
  def bonus
    {:str => 2, :dex => -1, :pow => 0}
  end
  
  def inventory
    return self.inventory_items
  end
end
