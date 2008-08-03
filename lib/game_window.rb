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
    
    @player = @area.player
    @player.add_listener(:game_over, self)
    @inventory = @player.inventory
    
    @time = 0
    @paused = false

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
    unless @paused || @game_over
      @time += 1
      @area.update if @time % 10 == 0
    end
  end
  
  def button_down(id)
    case id
    when Gosu::Button::KbSpace
      @paused = !@paused
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
    elsif @paused
      @big_font.draw("=PAUSED=", 180, 200, 20000)
    end
  end
end