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

app_files = %w[task manager random observable]
app_files.each {|f| require "#{lib}#{f}.rb" }

entity_files = %w[game_entity plant creature animals player goblin]
entity_files.each {|f| require "#{lib}#{f}.rb" }

map_files = %w[area cell diamond_square]
map_files.each {|f| require "#{lib}#{f}.rb" }

item_files = %w[item prize seed]
item_files.each {|f| require "#{lib}#{f}.rb" }



if __FILE__ == $0
  window = GameWindow.new
  window.main
end
