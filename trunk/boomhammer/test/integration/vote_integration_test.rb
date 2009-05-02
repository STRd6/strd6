require 'test_helper'

class VoteIntegrationTest < ActiveSupport::TestCase
  context "Accounts" do
    setup do
      @image = Factory :image
      @account = Factory :account
    end

    should "only allow one up vote per account per votable" do
      @image.vote_up(@account)

      assert_raise ActiveRecord::RecordInvalid do
        @image.vote_up(@account)
      end
    end
  end

  context "Power voting" do
    setup do
      @accounts = []

      6.times do
        @accounts << Factory(:account)
      end

      @image = Factory :image
    end

    should "convert to level 1 when two up votes are applied" do
      assert_difference "@image.level", 1, "Image must gain one level" do
        @image.vote_up(@accounts[0])

        assert_equal false, @image.up_votes.first.converted?, "Votes start out unconverted"

        @image.vote_up(@accounts[1])

        @image.up_votes.each do |vote|
          assert_equal true, vote.converted?, "Votes must convert"
        end
      end
    end

    should "convert to level 2 when six up votes are applied" do
      assert_difference "@image.level", 2, "Image must gain two levels" do
        6.times do |i|
          @image.vote_up(@accounts[i])
        end
      end
    end

    should "convert to level -1 when two down votes are applied" do
      assert_difference "@image.level", -1, "Image must lose one level" do
        @image.vote_down(@accounts[0])

        assert_equal false, @image.down_votes.first.converted?, "Votes start out unconverted"

        @image.vote_down(@accounts[1])

        @image.down_votes.each do |vote|
          assert_equal true, vote.converted?, "Votes must convert"
        end
      end
    end

    should "convert to level -2 when six down votes are applied" do
      assert_difference "@image.level", -2, "Image must lose two levels" do
        6.times do |i|
          @image.vote_down(@accounts[i])
        end
      end
    end

    should "end up with +1 after six up votes and two down votes" do
      assert_difference "@image.level", 1, "Image must lose one level" do
        6.times do |i|
          @image.vote_up(@accounts[i])
        end

        2.times do |i|
          @image.vote_down(@accounts[i])
        end
      end
    end
  end
end