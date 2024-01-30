require "test_helper"

class ChangeLogTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup do
    @change_log = change_logs(:one)
    @change_log_place = change_logs(:two)
    @place = places(:one)
  end

  teardown do
    @change_log = nil
    @change_log_place = nil
    @place = nil
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

  test "changeable_id should be present" do
    @change_log.changeable_id = nil
    assert_not @change_log.valid?
  end

  test "changeable_type should be present" do
    @change_log.changeable_type = nil
    assert_not @change_log.valid?
  end

  # Place JSONB validations
  test "name should have a minimum length" do
    @change_log_place.name = "a"
    assert_not @change_log_place.valid?
    @change_log_place.name = "aa"
    assert @change_log_place.valid?
  end

  test "name should have a maximum length" do
    @change_log_place.name = "a" * 101
    assert_not @change_log_place.valid?
    @change_log_place.name = "a" * 100
    assert @change_log_place.valid?
  end


  test "Google Place ID should have a minimum length if address is present" do
    @change_log_place.address = "Rua do Alecrim, 100, Lisboa"
    @change_log_place.place_id = "a"
    assert_not @change_log_place.valid?
  end

  test "Google Place ID should have a maximum length if address is present" do
    @change_log_place.address = "Rua do Alecrim, 100, Lisboa"
    @change_log_place.place_id = "a" * 81
    assert_not @change_log_place.valid?
  end

  test "address should have a minimum length" do
    @change_log_place.address = "a" * 15
    assert @change_log_place.valid?
    @change_log_place.address = "a" * 14
    assert_not @change_log_place.valid?
  end

  test "address should have a maximum length" do
    @change_log_place.address = "a" * 500
    assert @change_log_place.valid?
    @change_log_place.address = "a" * 501
    assert_not @change_log_place.valid?
  end

  test "vegan should be true or false" do
    @change_log_place.vegan = "true"
    assert @change_log_place.valid?
    @change_log_place.vegan = "false"
    assert @change_log_place.valid?
    @change_log_place.vegan = "maybe"
    assert_not @change_log_place.valid?
  end

  test "instagram_handle should have a maximum length" do
    @change_log_place.instagram_handle = "a" * 30
    assert @change_log_place.valid?
    @change_log_place.instagram_handle = "a" * 31
    assert_not @change_log_place.valid?
  end

  test "instagram_handle can include letters, numbers, periods and underscores" do
    @change_log_place.instagram_handle = "a1._"
    assert @change_log_place.valid?
  end

  test "instagram_handle cannot include spaces" do
    @change_log_place.instagram_handle = "a b"
    assert_not @change_log_place.valid?
  end

  test "instagram_handle cannot include special characters" do
    @change_log_place.instagram_handle = "a!b"
    assert_not @change_log_place.valid?
  end

  test "instagram handle should be all lowercase" do
    @change_log_place.instagram_handle = "Abc"
    assert @change_log_place.valid?
  end

  test "facebook_handle should have a maximum length" do
    @change_log_place.facebook_handle = "a" * 50
    assert @change_log_place.valid?
    @change_log_place.facebook_handle = "a" * 51
    assert_not @change_log_place.valid?
  end

  test "facebook_handle can include letters, numbers, periods and underscores" do
    @change_log_place.facebook_handle = "a1._"
    assert @change_log_place.valid?
  end

  test "facebook_handle cannot include spaces" do
    @change_log_place.facebook_handle = "a b"
    assert_not @change_log_place.valid?
  end

  test "facebook_handle cannot include special characters" do
    @change_log_place.facebook_handle = "a!b"
    assert_not @change_log_place.valid?
  end

  test "facebook handle should be all lowercase" do
    @change_log_place.facebook_handle = "Abc"
    assert @change_log_place.valid?
  end

  test "x_handle should have a maximum length" do
    @change_log_place.x_handle = "a" * 20
    assert @change_log_place.valid?
    @change_log_place.x_handle = "a" * 21
    assert_not @change_log_place.valid?
  end

  test "x_handle can include letters, numbers, periods and underscores" do
    @change_log_place.x_handle = "a1._"
    assert @change_log_place.valid?
  end

  test "x_handle cannot include spaces" do
    @change_log_place.x_handle = "a b"
    assert_not @change_log_place.valid?
  end

  test "x_handle cannot include special characters" do
    @change_log_place.x_handle = "a!b/"
    assert_not @change_log_place.valid?
  end

  test "x handle should be all lowercase" do
    @change_log_place.x_handle = "Abc"
    assert @change_log_place.valid?
  end


  test "web_url should be a correct format" do
    @change_log_place.web_url = "www.google.com"
    assert_not @change_log_place.valid?
    @change_log_place.web_url = "https://www.google.com"
    assert_not @change_log_place.valid?
    @change_log_place.web_url = "google.com"
    assert @change_log_place.valid?
  end

  test "email should be a correct format" do
    @change_log_place.email = "test@test.com"
    assert @change_log_place.valid?
    @change_log_place.email = "test"
    assert_not @change_log_place.valid?
  end

  test "phone should be a correct format" do
    @change_log_place.phone = "3123640772"
    assert @change_log_place.valid?
    @change_log_place.phone = "5071234567"
    assert @change_log_place.valid?
    @change_log_place.phone = "1"
    assert_not @change_log_place.valid?
  end

  test "tag_ids can't be more than the number of tags" do
    @change_log_place.tag_ids = [ 1, 2, 3, 4, 5, 6, 7, 8 ]
    assert_not @change_log_place.valid?
  end
  # Place JSONB validations end

  # Menu JSONB validations
  test "menu name should have a minimum length" do
    @change_log.name = "a"
    assert @change_log.valid?
    @change_log.name = ""
    assert_not @change_log.valid?
  end

  test "menu name should have a maximum length" do
    @change_log.name = "a" * 51
    assert_not @change_log.valid?
  end

  test "menu description should have a maximum length" do
    @change_log.description = "a" * 500
    assert @change_log.valid?
    @change_log.description = "a" * 501
    assert_not @change_log.valid?
  end

  test "menu product_category should be present" do
    @change_log.product_category = nil
    assert_not @change_log.valid?
  end

  test "menu product_category should be in the list" do
    @change_log.product_category = "Pizza"
    assert_not @change_log.valid?
  end

  test "menu price should be a number" do
    @change_log.price = "a"
    assert_not @change_log.valid?
    @change_log.price = 1
    assert @change_log.valid?
  end

  test "menu price can be nil" do
    @change_log.price = nil
    assert @change_log.valid?
  end
  # Menu JSONB validations end

  # Public methods
  test "should approve place edit" do
    @change_log = change_logs(:three)
    @change_log.images.attach(fixture_file_upload("test.png"))
    @change_log.valid?
    @change_log.approve_place_edit
    @place.reload
    assert_equal @change_log.name, @place.name
    assert_equal @change_log.address, @place.address
    assert_equal @change_log.vegan, @place.vegan
    assert_equal @change_log.instagram_handle, @place.instagram_handle
    assert_equal @change_log.facebook_handle, @place.facebook_handle
    assert_equal @change_log.x_handle, @place.x_handle
    assert_equal @change_log.web_url, @place.web_url
    assert_equal @change_log.email, @place.email
    assert_equal @change_log.phone.to_s, @place.phone
    # assert_equal @change_log.tag_ids, @place.tags.ids
    assert_equal @place.images.count, 1
    assert_equal @change_log.user.id, @place.contributors.first
    assert_equal @change_log.user.points, 1
  end
end
