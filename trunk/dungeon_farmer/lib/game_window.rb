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
    @player = @area.player
    @time = 0
    @target_cell = nil
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
      @target_cell.selected = false if @target_cell
      @target_cell = cell_under_mouse
      @target_cell.selected = true if @target_cell
      @player.path = @area.path(@player.cell, @target_cell)
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
    @font.draw("Seeds #{@player.seeds}", 0, 0, 20000)
    #@image.draw(0,0, 1)
  end
end