#!/usr/bin/ruby -w

require 'yaml'

require 'RMagick'
include Magick

class ImageFriend
  attr_accessor :red, :green, :blue
  
  def initialize()
    @functions = ["Math.sin(Math::PI * &)", "Math.cos(Math::PI * &)", "(& + &)/2", "& * &", "(&) ** 3"]
    
    # Set default values
    @red = "0"
    @green = "0"
    @blue = "0"
  end
  
  def create_function(depth)
    
    #if depth is 0, return either x or y randomly
    if depth == 0
      return "p" if rand > 0.5
      return "q"
    end
    
    #grab a random function from the list
    myfunc = @functions[rand(@functions.length)]
    
    #for each instance of & in the function, replace with a new expression
    return myfunc.gsub("&") { create_function(depth - 1) }
  end

  def random_functions(depth)
    @red = create_function depth
    @green = create_function depth
    @blue = create_function depth
  end
  
  def load_functions(file_name)
    data = YAML::load(File.open(file_name))
    
    @red = parse data['red']
    @green = parse data['green']
    @blue = parse data['blue']
    
    return data['depth']
  end

  # Converts variables to latest style
  def parse(s)
    return s.to_s.gsub('x.to_f/n', 'p').gsub('y.to_f/n', 'q')
  end
  
  def create_image(n, m, t=1.0)
    image = Image.new(n, m)
    #create an array of pixels to push onto the image
    pixel_town = []
    
    m.times do |y|
      n.times do |x|
      
      p = x.to_f/n
      q = y.to_f/m
      
      #evaluate the rgb functions, magically using the current values of x and y, which the functions use!
      r = eval(@red)*65535
      g = eval(@green)*65535
      b = eval(@blue)*65535
      
      #add the rgb values to a pixel array
      pixel_town.push Pixel.new(r, g, b, 1)
      
      end
    end
    
    #blast the new pixels into the image!
    image.store_pixels(0, 0, n, m, pixel_town)
    
    return image
  end
  
end

#define width and height
n = ARGV[0]? ARGV[0].to_i : 256
m = ARGV[1]? ARGV[1].to_i : 256

#define depth of function
d = ARGV[2]? ARGV[2].to_i : 6;
#data_file = ARGV[2]


#create a new ImageFriend and use its createfunction method to create functions for the rgb values
image_friend = ImageFriend.new

480.times do
  

  #d = image_friend.load_functions data_file

  image_friend.random_functions d


start = Time.new

f = image_friend.create_image(n, m)

stop = Time.new
puts "Running time: #{stop - start}" 

tstamp = stop.to_i.to_s
f.write(tstamp + '.png')

file = File.open(tstamp + '.txt', 'w')
file.puts "width: #{n}"
file.puts "height: #{m}"
file.puts "depth: #{d}"
file.puts "red: #{image_friend.red}"
file.puts "green: #{image_friend.green}"
file.puts "blue: #{image_friend.blue}"
file.close
end

exit