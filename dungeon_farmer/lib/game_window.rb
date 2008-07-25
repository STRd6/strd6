class GameWindow < Gosu::Window
  def initialize
    super(512, 512, false)
    self.caption = "Dungeon Farmer"
    
    ImageLoader.instance.set_window(self)
    #arrays = DiamondSquare.go(9)
    #@image = Gosu::Image.new(self, ImageMaker.create(512, 512, arrays) {|f| ImageMaker.cloud_color f}, false)
    #@image3 = Gosu::Image.new(self, ImageMaker.create(512, 512, arrays) {|f| ImageMaker.land_color f}, false)
    @font = Gosu::Font.new(self, Gosu::default_font_name, 12)

    @area = Area.new(32, 32)
    @cells = @area.cells
    @target_cell = nil
    @to_plant = []
    
    @player = @area.player
    @player.add_listener(:plant, self)
    @player.add_listener(:no_path, self)
    @goblin = @area.goblin
    
    @time = 0

    @cursor = ImageLoader.instance.load('cursor.png')
    @cursor_act = ImageLoader.instance.load('seedbag.png')
  end

  def update
    @time += 1
    @area.update if @time % 10 == 0
  end
  
  def button_down(id)
    case id
    when 112
      @player.plant
    when Gosu::Button::KbLeft
      @player.west
    when Gosu::Button::KbRight
      @player.east
    when Gosu::Button::KbUp
      @player.north
    when Gosu::Button::KbDown
      @player.south
    when Gosu::Button::MsLeft
      mouse_downed
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
        cell.selected = true
        @to_plant.push cell unless @to_plant.include?(cell)
      end
    end
  end
  
  def plant(cell)
    cell.selected = false
    @to_plant.delete(cell)
  end
  
  def no_path(player)
    unless @to_plant.empty?
      player.path = @area.path(player.cell, @to_plant.slice(0))
    end
  end
  
  def cell_under_mouse
    row = mouse_y.to_i/16
    col =  mouse_x.to_i/16
    @cells[row*32 + col]
  end

  def draw
    @cells.each { |cell| cell.draw }
    @cursor.draw(mouse_x, mouse_y, 10000)
    @cursor_act.draw(mouse_x, mouse_y, 10000)
    @font.draw("Seeds\nP: #{@player.seeds}\nG: #{@goblin.seeds}", 0, 0, 20000)
    #@image.draw(0,0, 1)
  end
end