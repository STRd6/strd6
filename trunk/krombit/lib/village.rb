class Village
  attr_reader :items, :residents
  
  def initialize
    @items = []
    @residents = []
    @stockpile = Stockpile.new({})
  end
  
  def arm!
    @residents.each do |c|
      item = @items.random
      @items.delete(item)
      
      old_item = c.equip item
      @items.push old_item if old_item
    end
  end
  
  #def add_resident(creature)
  #  @residents.push creature unless residents.include? creature
  #end
  
  #def add_item(item)
  #  @items.push item unless items.include? item
  #end
  
  def method_missing(name, *args)
    words = name.to_s.split('_')
    
    return super(name, *args) unless words.shift == 'add'
    # Make add_ methods here
    
    array = eval("#{words[0]}s")
    array.push args[0] unless array.include? args[0]
    
  end
  
end
