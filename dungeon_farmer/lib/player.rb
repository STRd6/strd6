class Player < Creature
  attr_reader :name, :location, :inventory
  
  def initialize(name)
    super 'farmer.png'
    @name = name
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
  
  def update
    @age += 1
    
    if @age % 2 == 0
      if @path.empty?
        @path = find_path
      
        if @act_cell == @cell
          target = @act_cell
          @act_cell = nil
        end
      else
        target = @path.slice! 0
      end      
      
      if target
        move(target)
        if @current_task && @current_task.perform_cells.include?(@cell)
          case @current_task.activity
          when :plant
            plant
          when :get
            pick_up
          when :dig
            dig
          end
          
          @managers[@current_task.activity].accomplish @current_task
          @current_task = nil
          @path = []
        end
      end
      
    end
    
#    if @age % 64 == 0
#      @food -= 1
#      if @food < 7
#        3.times do
#          eat
#        end
#      end
#      
#      if @food <= 0
#        notify(:game_over)
#      end
#    end
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
  
  def add_task(task)
    @managers[task.activity].add_task(task)
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
