require "test_helper"

class MenuTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup do
    @menu = menus(:one)
  end

  teardown do
    @menu = nil
  end

# ASSOCIATIONS START
test "should belong to place" do
    assert @menu.place
  end

  test "should belong to creator" do
    assert @menu.creator
  end

  test "should have many change_logs" do
    assert @menu.change_logs
  end

  test "should have many likes" do
    assert @menu.likes
  end

  test "should have one attached image" do
    assert @menu.image
  end
  # ASSOCIATIONS END


  # VALIDATIONS START
  test "should be valid" do
    assert @menu.valid?
  end

  test "name should be present" do
    @menu.name = "     "
    assert_not @menu.valid?
  end

  test "name should not be too long" do
    @menu.name = "a" * 51
    assert_not @menu.valid?
  end

  test "description should not be too long" do
    @menu.description = "a" * 501
    assert_not @menu.valid?
  end

  test "product_category should be present" do
    @menu.product_category = nil
    assert_not @menu.valid?
  end

  test "place_id should be present" do
    @menu.place_id = nil
    assert_not @menu.valid?
  end

  test "creator_id should be present" do
    @menu.creator_id = nil
    assert_not @menu.valid?
  end

  test "approved should be present" do
    @menu.approved = nil
    assert_not @menu.valid?
  end

  test "active should be present" do
    @menu.active = nil
    assert_not @menu.valid?
  end

  test "product_category should be valid" do
    exception = assert_raises(ArgumentError) do
      @menu.product_category = "invalid"
    end
    assert_equal "'invalid' is not a valid product_category", exception.message
  end
  # VALIDATIONS END


  # SCOPES START
  test "should be scoped with product_category, approved and active" do
    food_menu1 = menus(:one)
    most_liked_food_menu = menus(:two)
    non_food_menu = menus(:three)
    not_approved_menu = menus(:four)
    not_active_menu = menus(:five)

    assert_equal [ most_liked_food_menu, food_menu1 ], Menu.food, "Menus.food should return food menus and order them by likes_count"
    assert_not_includes Menu.food, non_food_menu
    assert_not_includes Menu.food, not_approved_menu
    assert_not_includes Menu.food, not_active_menu
  end
  # SCOPES END

  # METHODS START
  test "should approve" do
    not_approved_menu = menus(:four)
    not_approved_menu.approve
    assert not_approved_menu.approved
  end

  test "should be liked by user" do
    user = users(:one)
    @menu.like(user)
    assert @menu.liked_by?(user)
    assert_equal 1, @menu.likes.count
  end

  test "should be unliked by user" do
    user = users(:one)
    @menu.like(user)
    assert @menu.liked_by?(user)
    assert_equal 1, @menu.likes.count
    @menu.unlike(user)
    assert_not @menu.liked_by?(user)
    assert_equal 0, @menu.likes.count
  end

  test "should be most liked" do
    place = places(:one)
    most_liked_menu = menus(:three)
    assert_not @menu.most_liked?(place)
    assert most_liked_menu.most_liked?(place)
  end

  test "should not be most liked" do
    place = places(:one)
    assert_not @menu.most_liked?(place)
  end

  test "should not be most liked if likes_count is less than 5" do
    place = places(:one)
    @menu.likes_count = 4
    assert_not @menu.most_liked?(place)
  end

  test "should not be most liked if not approved" do
    place = places(:one)
    @menu.approved = false
    assert_not @menu.most_liked?(place)
  end

  test "should not be most liked if not active" do
    place = places(:one)
    @menu.active = false
    assert_not @menu.most_liked?(place)
  end

  test "should not be most liked if not approved and not active" do
    place = places(:one)
    @menu.approved = false
    @menu.active = false
    assert_not @menu.most_liked?(place)
  end

  test "should not be most liked if likes_count is less than max likes" do
    place = places(:one)
    @menu.likes_count = 4
    assert_not @menu.most_liked?(place)
  end
  # METHODS END

  # CALLBACKS START
  test "should destroy associated change_logs" do
    assert_difference "ChangeLog.count", -1 do
      @menu.destroy
    end
  end

  test "should destroy associated likes" do
    assert_difference "Like.count", -1 do
      @menu.destroy
    end
  end

  test "should destroy associated image when menu is destroyed" do
    @menu.save
    file = fixture_file_upload("test.png")
    @menu.image.attach(file)

    assert_difference "ActiveStorage::Attachment.count", -1 do
      @menu.destroy
    end
  end
  # CALLBACKS END

  # PRIVATE METHODS START
  test "should add error if image type is invalid" do
    file = fixture_file_upload("test.gif")
    @menu.image.attach(file)
    assert_not @menu.valid?
    assert_equal I18n.t("activerecord.attributes.menu.image_invalid"), @menu.errors[:image].first
  end

  test "should add error if image size is too big" do
    file = fixture_file_upload("testbig.jpeg", "image/jpeg")
    @menu.image.attach(file)
    assert_not @menu.valid?
    assert_equal I18n.t("activerecord.attributes.menu.image_size"), @menu.errors[:image].first
  end
  # PRIVATE METHODS END
end
