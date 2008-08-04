require 'rubygems'

lib = File.dirname(__FILE__) + '/'

$:.unshift lib + '../gratr-0.4.3/lib'
require 'gratr.rb'
require 'gratr/import'

$RUBYGAME = ARGV[0] == 'mode=rubygame'

if $RUBYGAME
  require 'rubygame'
  require 'rubygame/sfont'
  require "#{lib}image_adapter.rb"
else
  require 'gosu'
  
  class GameWindow < Gosu::Window
    
  end
end

view_files = %w[graphical image_loader game_window]
view_files.each {|f| require "#{lib}#{f}.rb" }

files = %w[observable item prize seed fruit game_entity plant area creature animals player goblin cell diamond_square random task manager]
files.each {|f| require "#{lib}#{f}.rb" }

if __FILE__ == $0
  window = GameWindow.new
  window.main
end
