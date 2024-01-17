require "test_helper"

class ChangeLogTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup do
    @change_log = change_logs(:one)
  end

  teardown do
    @change_log = nil
  end

  test "should be valid" do
    assert @change_log.valid?
  end

  # ASSOCIATIONS START
  test "should belong to menu" do
    assert_equal "Menu", @change_log.changeable_type
    assert @change_log.changeable
  end

  test "should belong to place" do
    @change_log = change_logs(:two)
    assert_equal "Place", @change_log.changeable_type
    assert @change_log.changeable
  end

    test "should belong to user" do
      assert @change_log.user
    end

    test "should have many images" do
      assert @change_log.images
    end

    test "should have image attached" do
      assert @change_log.image
    end
  # ASSOCIATIONS END
  # VALIDATIONS START
  test "user_id should be present" do
    @change_log.user_id = nil
    assert_not @change_log.valid?
  end
end
