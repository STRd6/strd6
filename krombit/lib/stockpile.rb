class Stockpile

  def initialize(stocks)
    @stocks = stocks
  end

  # Not thread safe
  def add(stocks)
    stocks.each do |resource, amt| 
      if @stocks[resource]
        @stocks[resource] += amt
      else
        @stocks[resource] = amt
      end
    end
  end
  
  # Not thread safe
  def remove(stocks)
    stocks.each do |resource, amt| 
      return false if @stocks[resource] < amt
    end
    
    stocks.each do |resource, amt| 
      @stocks[resource] -= amt
    end
    
    return true
  end

  def display
    puts to_s
    @stocks.each do |resource, amt|
      puts "#{resource}: #{amt}"
    end
  end
  
  def method_missing(name, *args)
    return @stocks[name] if @stocks.has_key? name
    super(name, *args)
  end

end
