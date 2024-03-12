require "test_helper"

class TagTest < ActiveSupport::TestCase
  setup do
    @tag = tags(:italian_cuisine)
  end

  teardown do
    @tag = nil
  end

  test "should be valid" do
    assert @tag.valid?
  end

  test "shoud has and belongs to many places" do
    assert @tag.places
  end

  test "name should be present" do
    @tag.name = "     "
    assert_not @tag.valid?
  end

  test "name should be unique" do
    tag = Tag.new(name: @tag.name)
    assert_not tag.valid?
  end

  test "name should not be too long" do
    @tag.name = "a" * 31
    assert_not @tag.valid?
  end

  test "name should be downcased before save" do
    @tag.name = "ITALIAN"
    @tag.save
    assert_equal "italian", @tag.name
  end

  test "name should be unique case insensitive" do
    tag = Tag.new(name: @tag.name.upcase)
    assert_not tag.valid?
  end
end
