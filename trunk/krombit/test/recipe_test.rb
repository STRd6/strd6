require File.dirname(__FILE__) + '/test_helper.rb'

class RecipeTest < Test::Unit::TestCase
  def test_new
    assert Recipe.new({}, {})
  end
  
  def test_load
    assert Recipe.load('plank')
  end
  
  def test_concoct
    recipe = Recipe.load('plank')
    sp = Stockpile.new(:wood => 1)
    recipe.concoct_from(sp)
    recipe.concoct_from(sp)
    
    assert_equal 1, sp.plank
  end
  
end
