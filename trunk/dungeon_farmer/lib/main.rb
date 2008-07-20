require 'gosu'

lib = File.dirname(__FILE__) + '/'
files = %w[ graphical seed plant area player cell diamond_square image_maker image_loader game_window]
files.each {|f| require lib+"#{f}.rb" }


if __FILE__ == $0
  window = GameWindow.new
  window.show
end
