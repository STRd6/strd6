require 'gosu'

lib = File.dirname(__FILE__) + '/'
files = %w[graphical observable item prize seed fruit plant area creature dog player goblin cell diamond_square image_maker image_loader game_window random]
files.each {|f| require lib+"#{f}.rb" }

class Array
  def random
    self[rand(length)]
  end
end


if __FILE__ == $0
  window = GameWindow.new
  window.show
end
