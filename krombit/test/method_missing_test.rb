require File.dirname(__FILE__) + '/test_helper.rb'

class Child_String < String
  def method_missing(name, *args)
    puts "Method missing"
    super(name, *args)
  end

  def test
    "test"
  end
end

class MethTest < Test::Unit::TestCase
  def test_mm
    cs = Child_String.new

    puts cs.length
    puts cs.test
    
  end
end
