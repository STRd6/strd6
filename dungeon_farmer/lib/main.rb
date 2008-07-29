require 'rubygems'
require 'RMagick'
require 'gosu'

require File.dirname(__FILE__) + '/../gratr-0.4.3/lib/gratr.rb'
require File.dirname(__FILE__) + '/../gratr-0.4.3/lib/gratr/import'

lib = File.dirname(__FILE__) + '/'
files = %w[graphical observable item prize seed fruit plant area creature dog player goblin cell diamond_square image_maker image_loader game_window random]
files.each {|f| require lib+"#{f}.rb" }

if __FILE__ == $0
  window = GameWindow.new
  window.show
end
