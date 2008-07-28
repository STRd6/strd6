class Player < Creature
  attr_reader :name, :location, :inventory
  
  def initialize(name)
    super 'farmer.png'
    @name = name
    @cell = nil
    @age = 0
    @seeds = 5
    init_inventory
    
    @inventory.items << Fruit.new
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
  
  def move(cell)
    @cell.delete(self) if @cell
    @cell = cell
    @cell << self
  end
  
  def dig(cell)
    puts "#{self} is digging at #{cell}"
    notify(:dig, @cell, cell)
  end
  
  def update
    @age += 1
    
    if @age % 2 == 0
      if path.empty?
        notify(:no_path, self)
      else
        self.target = path.slice! 0
      end
      
      if target
        move(target)
        if path == []
          self.target = nil
          
          case task
          when :plant
            plant
          when :get
            pick_up
          when :dig
            @cell.neighbours.each do |c|
              if c.to_dig
                dig c
                break
              end
            end
            notify(:clear_target, :dig, @cell)
          end
          
          @task = @next_task if @next_task
          @next_task = nil
          
        end
      else
        @task = @next_task if @next_task
        @next_task = nil
      end
      
    end
    
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
  
  def pick_up
    seeds = @cell.seeds
    @cell.seeds -= seeds
    @seeds += seeds
    
    items = @cell.contents.select { |item| item.can_pick_up? }
    @cell.contents -= items
    @inventory.items.push(*items)
    @score_valid = false
    notify(:pick_up, self, @cell)
  end
  
  def obstructs?
    true
  end
  
  def remove
    @food -= 1
  end

  private
  
  def eat
    food = @inventory.items.find {|item| item.instance_of?(Fruit)}
    
    if food
      @inventory.items.delete(food)
      @food += 1
      @score_valid = false
    end
  end
  
  def init_inventory
    @inventory = Object.new
    
    @inventory.instance_eval do
      @items = []
      @font = ImageLoader.instance.font
    end
    
    def @inventory.items
      @items
    end
    
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
