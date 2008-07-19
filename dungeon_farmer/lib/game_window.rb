class GameWindow < Gosu::Window
  def initialize
    super(512, 512, false)
    self.caption = "Gosu Tutorial Game"
    
    ImageLoader.instance.set_window(self)
    #arrays = DiamondSquare.go(9)
    #@image = Gosu::Image.new(self, ImageMaker.create(512, 512, arrays) {|f| ImageMaker.cloud_color f}, false)
    #@image3 = Gosu::Image.new(self, ImageMaker.create(512, 512, arrays) {|f| ImageMaker.land_color f}, false)

    @area = Area.new(32, 32)
    @cells = @area.cells
    @player = @area.player
    @time = 0
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
    end
  end

  def draw
    @cells.each { |cell| cell.draw }
  end
end