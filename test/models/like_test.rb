require "test_helper"

class LikeTest < ActiveSupport::TestCase
  setup do
    @like = likes(:one)
  end

  teardown do
    @like = nil
  end

  test "should be valid" do
    assert @like
  end

  # ASSOCIATIONS START
  test "should belong to user" do
    assert @like.user
  end

  test "should have polymorphic association" do
    assert_respond_to @like, :record
  end
  # ASSOCIATIONS END
end
