require File.dirname(__FILE__) + '/test_helper.rb'

class DescriptionTest < Test::Unit::TestCase
  def test_new
    15.times do 
      d = Description.new
      puts d.describe
    end
  end
end
