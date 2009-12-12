require 'test_helper'

class TreeworldTest < ActiveSupport::TestCase
  context "treeworld" do
    should "be able to generate" do
      world = Treeworld.generate

      assert world.trees.size > 0, "Treeworlds should have trees!"
    end
  end
end
