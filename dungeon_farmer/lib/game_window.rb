class GameWindow < Gosu::Window
  def initialize
    super(512, 512, false)
    self.caption = "Dungeon Farmer"
    
    @actions = [:plant, :dig, :get]
    @action_index = 0
   
    @height = @width = 32
    
    ImageLoader.instance.set_window(self)
    
    @font = Gosu::Font.new(self, Gosu::default_font_name, 12)
    @big_font = Gosu::Font.new(self, Gosu::default_font_name, 42)
    
    @area = Area.new(@width, @height)
    @cells = @area.cells
    @target_cell = nil
    
    @target_cells = {}
    @task_cells = {}
    @actions.each { |action| @task_cells[action] = []; @target_cells[action] = [] }
    @task_cells[:get] = @cells.select {|c| c.has_resource? }
    
    
    @player = @area.player
    @player.add_listener(:plant, self)
    @player.add_listener(:no_path, self)
    @player.add_listener(:pick_up, self)
    @player.add_listener(:dig, self)
    @player.add_listener(:game_over, self)
    @inventory = @player.inventory
    
    
    @area.chips.each do |chip|
      chip.add_listener(:plant, self)
      chip.add_listener(:pick_up, self)
      chip.add_listener(:no_path_s, self)
    end
    
    @time = 0

    @cursor = ImageLoader.instance.load('cursor.png')
    @cursors = load_cursors
  end
  
  def load_cursors
    seed_bag = ImageLoader.instance.load('seedbag.png')
    pick = ImageLoader.instance.load('pickrock.png')
    hand = ImageLoader.instance.load('handpick.png')
    
    {:plant => seed_bag, :dig => pick, :get => hand}
  end
  
  def action
    @actions[@action_index % @actions.size]
  end

  def update
    @time += 1
    unless @game_over
      @area.update if @time % 10 == 0
    end
  end
  
  def button_down(id)
    case id
    when Gosu::Button::MsLeft
      mouse_downed
    when Gosu::Button::MsWheelUp, Gosu::Button::MsRight
      puts "Next Action"
      @action_index += 1
    when Gosu::Button::MsWheelDown, Gosu::Button::MsMiddle
      puts "Wheel Down!"
      @action_index -= 1
    end
  end
  
  def button_up(id)
    case id
    when Gosu::Button::MsLeft
      mouse_released
    end
  end
  
  def mouse_downed
    @c1 = cell_under_mouse
  end
  
  def mouse_released
    @c2 = cell_under_mouse
    
    if @c1 && @c2
      x1 = [@c1.x, @c2.x].min
      x2 = [@c1.x, @c2.x].max
      y1 = [@c1.y, @c2.y].min
      y2 = [@c1.y, @c2.y].max
      
      @area.cells_in(x1, x2, y1, y2).each do |cell|
        if action == :dig
          if cell.blocked?
            @player.add_task(Task.new(cell, cell.neighbours, :dig))
          end
        else
          unless cell.blocked?
            @player.add_task(Task.new(cell, [cell], action))
          end
        end
      end
      
      @player.activity = action
    end
  end
  
  def plant(cell, plant)
    @task_cells[:plant].delete(cell)
    plant.add_listener(:seed, self)
  end
  
  def no_path(player)
    
    
#    priorities = []
#    
#    if player.seeds > 0
#      case player.task
#      when :dig
#        priorities << {:task => :dig, :array => @target_cells[:dig]}
#      when :get
#        priorities << {:task => :get, :array => @task_cells[:get]}
#        priorities << {:task => :plant, :array => @task_cells[:plant]}
#      else
#        priorities << {:task => :plant, :array => @task_cells[:plant]}
#      end
#    end
#    
#    priorities << {:task => :get, :array => @task_cells[:get]}
#    priorities << {:task => :dig, :array => @target_cells[:dig]}
#    
#    path_from_priority(player, priorities)
  end
  
  def no_path_s(chip)
    priorities = []
    
    case chip.task
    when :get
      priorities << {:task => :get, :array => @task_cells[:get]}
    end
    
    path_from_priority(chip, priorities)
  end
  
  def path_from_priority(creature, priorities)
    priorities.each do |priority|
      cell = rotate(priority[:array])
      if cell
        path = @area.path(creature.cell, cell)
        
        if path.empty?
          priority[:array].delete(cell)
        else
          creature.task = priority[:task]
          creature.path = path
          return
        end
      end
    end
  end
  
  def pick_up(creature, cell)
    puts "#{creature} picked stuff up!"
    @task_cells[:get].delete(cell)
  end
  
  def seed(cell)
    @task_cells[:get] << cell unless @task_cells[:get].include?(cell)
  end
  
  def dig(standing, task_cell)
    task_cell.dig
    @area.connect task_cell
    @task_cells[:dig].delete(task_cell)
    
    if rand(5) == 0
      goblin = @area.uncover_goblin(task_cell) 
      goblin.add_listener(:accost, self)
    end
    
    if rand(8) == 0
      task_cell << Prize.new
      @task_cells[:get] << task_cell unless @task_cells[:get].include?(task_cell)
    end
    
    @target_cells[:dig].delete(standing)
  end
  
  def accost(creature, cell)
    cell.contents.each do |content|
      content.remove unless content == creature
    end
  end
  
  def game_over
    @game_over = true
  end
  
  def rotate(array)
    return nil if array.empty?
    cell = array.slice!(0)
    array << cell
    return cell
  end
  
  def cell_under_mouse
    row = mouse_y.to_i/16
    col =  mouse_x.to_i/16
    @cells[row*@width + col]
  end

  def draw
    @cells.each { |cell| cell.draw }
    @inventory.draw(450, 5)
    @cursor.draw(mouse_x, mouse_y, 10000)
    @cursors[action].draw(mouse_x, mouse_y, 10000)
    @font.draw("Seeds: #{@player.seeds}", 0, 0, 20000)
    @font.draw("Food: #{@player.food}", 0, 16, 20000)
    
    if @game_over
      @big_font.draw("Game Over", 180, 200, 20000)
      @font.draw("Score: #{@player.score}", 240, 265, 20000)
    end
  end
end