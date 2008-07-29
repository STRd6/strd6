module ImageMaker
  include Magick
  QuantumRange = MaxRGB
  
  def self.create(rows, cols, arrays)
    image = Image.new(cols, rows)
    image.matte = true
    pixel_town = []
    
    rows.times do |row|
      cols.times do |col|
        colors = (yield arrays[row][col]).map { |f| f*QuantumRange }
        pixel_town.push Pixel.new(*colors)
      end
    end
    
    image.store_pixels(0, 0, cols, rows, pixel_town)
    return image
  end
  
  def self.blank(width, height, bg_color='white')
    Magick::Image.new(width, height) {
      self.background_color = bg_color
    }
  end
  
  def self.cloud_color(f)
    return [1,1,1,0] if f < 0.0
    return [1,1,1,1*f] if f < 1
    return [1,1,1,1]
  end
  
  def self.land_color(f)
    return [0, 0, 0.5, 0] if f < 0.0
    return [0, 0, 0.5 + 1*f, 0] if f < 0.5
    return [0.3*f, 1*f, 0.25*f, 0] if f < 0.8
    return [1*f, 1*f, 1*f, 0] if f < 1
    return [1, 1, 1, 0]
  end
end
