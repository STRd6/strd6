class Player < Creature
  attr_reader :name, :location, :inventory
  
  def initialize(name)
    super 'farmer.png'
    @name = name

    init_inventory
    
    @items << Item.new("fruit.png", :value => 2, :edible => true)
    3.times { @items << Seed.new(Tree) }
    5.times { @items << Seed.new(Bush) }
    @food = 9
    
    @score = 0
    @score_valid = false
  end
  
  def food
    s = ''
    @food.times {s += '#'}
    return s
  end
  
  def score
    return @score if @score_valid
    
    @score = @inventory.items.inject(0) {|sum, item| sum + item.value }
    @score += @seeds
  end
  
  def to_s
    name
  end
  
  def scary?
    true
  end
  
  def update
    super
    
    if @age % 64 == 0
      @food -= 1
      if @food < 7
        3.times do
          eat
        end
      end
      
      if @food <= 0
        notify(:game_over)
      end
    end
  end
  
  def no_target

  end
  
  def get
    items = @cell.contents.select { |item| item.can_pick_up? }
    @cell.contents -= items
    @inventory.items.push(*items)
    @score_valid = false
  end
  
  def remove
    @food -= 1
  end

  private
  
  def eat
    food = @inventory.items.find {|item| item.edible? }
    
    if food
      @inventory.items.delete(food)
      @food += 1
      @score_valid = false
    end
  end
  
  def init_inventory
    @inventory = Object.new
    
    @inventory.instance_eval do
      @font = ImageLoader.instance.font
    end
    
    def @inventory.items
      @items
    end
    
    def @inventory.items=(items)
      @items = items
    end
    
    @inventory.items = @items
    
    def @inventory.draw(x, y)
      @font.draw("Inventory", x, y, 20000)
      i = 1
      @items.each do |item|
        item.draw(x + 32, y + 16*i, 100)
        i += 1
      end
    end
  end
end
