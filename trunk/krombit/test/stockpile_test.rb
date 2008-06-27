require File.dirname(__FILE__) + '/test_helper.rb'

class StockpileTest < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end

  def test_new
    stockpile = Stockpile.new(:wood => 100)
    assert stockpile.remove(:wood => 75)
    assert !stockpile.remove(:wood => 75)
    
    stockpile.add(:wood => 50)
    
    assert stockpile.remove(:wood => 75)
    
    stockpile.add(:stone => 50)
    
    stockpile.display
  end
  
  def test_mm
    wood_quantity = 100
    stockpile = Stockpile.new(:wood => wood_quantity)
    assert_equal wood_quantity, stockpile.wood
    
    begin
      stockpile.this_is_not_a_method
    rescue
      assert true
    else
      assert false
    end
  end
end
