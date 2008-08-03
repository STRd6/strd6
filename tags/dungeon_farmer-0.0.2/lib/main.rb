require 'rubygems'
require 'gosu'

$:.unshift File.dirname(__FILE__) + '/../gratr-0.4.3/lib'
require 'gratr.rb'
require 'gratr/import'

lib = File.dirname(__FILE__) + '/'
files = %w[graphical observable item prize seed fruit game_entity plant area creature animals player goblin cell diamond_square image_loader game_window random task manager]
files.each {|f| require lib+"#{f}.rb" }

if __FILE__ == $0
  window = GameWindow.new
  window.show
end
