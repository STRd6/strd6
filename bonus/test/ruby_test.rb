#!/usr/bin/ruby -w

require 'test/unit'

class RubyTest < Test::Unit::TestCase

  def args_length(*args)
    return args.length
  end
  
  def test_args_length
    assert_equal 1, args_length(:a => 1, :b =>2, :c => 3)
    assert_equal 2, args_length("first", :a => 1, :b =>2, :c => 3)
  end
  
end 


