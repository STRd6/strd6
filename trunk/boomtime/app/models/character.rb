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
  
  def image=(image)
    properties[:image] = image
  end
  
  def image
    properties[:image] || display_datum.image
  end
  
  def images
    Dir["#{RAILS_ROOT}/public/images/#{image_directory}*.png"].map do |f|
      f.gsub(/^(.*)\/(.*)\.png/, '\2')
    end
  end
  
  def get_pile(item)
    if item.owner == area
      if item.properties[:pile]
        item.properties[:pile].each do |resource, amount|
          if resources[resource]
            resources[resource] += amount
          else
            resources[resource] = amount
          end
        end
        save
        item.destroy
        return true
      else
        return false
      end
    else
      return false
    end
  end
  
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
