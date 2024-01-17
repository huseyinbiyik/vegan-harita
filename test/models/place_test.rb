# rubocop:disable Metrics/ClassLength

require "test_helper"

class PlaceTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  def setup
    @place = Place.new(name: "Test Place", address: "123 Test St", place_id: "1", latitude: "40.7128", vegan: true)
  end

  def teardown
    @place = nil
  end

  # VALIDATIONS START
  test "should be valid" do
    assert @place.valid?
  end

  test "name should be present" do
    @place.name = ""
    assert_not @place.valid?
    assert_equal [ "can't be blank" ], @place.errors[:name]
  end

  test "name should not be too long" do
    @place.name = "a" * 81
    assert_not @place.valid?
    assert_equal [ "is too long (maximum is 80 characters)" ], @place.errors[:name]
  end

  test "address should be present" do
    @place.address = ""
    assert_not @place.valid?
    assert_equal [ "can't be blank" ], @place.errors[:address]
  end

  test "address should not be too long" do
    @place.address = "a" * 501
    assert_not @place.valid?
    assert_equal [ "is too long (maximum is 500 characters)" ], @place.errors[:address]
  end

  test "address should be unique" do
    duplicate_place = @place.dup
    @place.save
    assert_not duplicate_place.valid?
    assert_equal [ "already exists" ], duplicate_place.errors[:address]
  end

  test "place_id should be present" do
    @place.place_id = ""
    assert_not @place.valid?
    assert_equal [ "can't be blank" ], @place.errors[:place_id]
  end

  test "place_id should be unique" do
    duplicate_place = @place.dup
    @place.save
    assert_not duplicate_place.valid?
    assert_equal [ "already exists" ], duplicate_place.errors[:place_id]
  end

  test "vegan should be true or false" do
    @place.vegan = nil
    assert_not @place.valid?
    assert_equal [ "is not included in the list" ], @place.errors[:vegan]
  end

  test "vegan should not be blank" do
    @place.vegan = ""
    assert_not @place.valid?
    assert_equal [ "is not included in the list" ], @place.errors[:vegan]
  end

  test "instagram_handle should be valid" do
    @place.instagram_handle = "instagram.com/invalid"
    assert_not @place.valid?
    assert_equal I18n.t("activerecord.attributes.place.instagram_invalid"), @place.errors[:instagram_handle].first
  end

  test "instagram_handle should not be too long" do
    @place.instagram_handle = "a" * 31
    assert_not @place.valid?
    assert_equal [ "is too long (maximum is 30 characters)" ], @place.errors[:instagram_handle]
  end

  test "instagram_handle can be blank" do
    @place.instagram_handle = ""
    assert @place.valid?
  end

  test "facebook_handle should be valid" do
    @place.facebook_handle = "facebook.com/invalid"
    assert_not @place.valid?
    assert_equal I18n.t("activerecord.attributes.place.facebook_invalid"), @place.errors[:facebook_handle].first
  end

  test "facebook_handle should not be too long" do
    @place.facebook_handle = "a" * 51
    assert_not @place.valid?
    assert_equal [ "is too long (maximum is 50 characters)" ], @place.errors[:facebook_handle]
  end

  test "facebook_handle can be blank" do
    @place.facebook_handle = ""
    assert @place.valid?
  end

  test "x_handle should be valid" do
    @place.x_handle = "x.com/invalid"
    assert_not @place.valid?
    assert_equal I18n.t("activerecord.attributes.place.x_invalid"), @place.errors[:x_handle].first
  end

  test "x_handle should not be too long" do
    @place.x_handle = "a" * 51
    assert_not @place.valid?
    assert_equal [ "is too long (maximum is 50 characters)" ], @place.errors[:x_handle]
  end

  test "x_handle can be blank" do
    @place.x_handle = ""
    assert @place.valid?
  end

  test "web url should be like google.com" do
    @place.web_url = "google.com"
    assert @place.valid?
  end

  test "web_url shouldn not be a simple string" do
    @place.web_url = "invalid"
    assert_not @place.valid?
    assert_equal [ "is invalid" ], @place.errors[:web_url]
  end

  test "web_url should not start with https" do
    @place.web_url = "https://www.google.com"
    assert_not @place.valid?
    assert_equal [ "is invalid" ], @place.errors[:web_url]
  end

  test "web_url should not start with http" do
    @place.web_url = "http://www.google.com"
    assert_not @place.valid?
    assert_equal [ "is invalid" ], @place.errors[:web_url]
  end

  test "web_url should not start with www" do
    @place.web_url = "www.google.com"
    assert_not @place.valid?
    assert_equal [ "is invalid" ], @place.errors[:web_url]
  end

  test "web_url can start with subdomains" do
    @place.web_url = "subdomain.google.com"
    assert @place.valid?
  end

  test "web_url can end with a path" do
    @place.web_url = "google.com/path"
    assert @place.valid?
  end

  test "web_url can be blank" do
    @place.web_url = ""
    assert @place.valid?
  end

  test "email should be a simple email address" do
    @place.email = "huseyin@gmail.com"
    assert @place.valid?
  end

  test "email should not be a simple string" do
    @place.email = "invalid"
    assert_not @place.valid?
    assert_equal [ "is invalid" ], @place.errors[:email]
  end

  test "email can be blank" do
    @place.email = ""
    assert @place.valid?
  end

  test "phone should be a valid phone number" do
    @place.phone = "5555555555"
    assert @place.valid?
  end

  test "phone can be landline" do
    @place.phone = "2125555555"
    assert @place.valid?
  end

  test "phone can not be more than 10 digits" do
    @place.phone = "55555555555"
    assert_not @place.valid?
    assert_equal [ "is invalid" ], @place.errors[:phone]
  end

  test "phone should not be string" do
    @place.phone = "invalid"
    assert_not @place.valid?
    assert_equal [ "is invalid" ], @place.errors[:phone]
  end

  test "phone can be blank" do
    @place.phone = ""
    assert @place.valid?
  end

  # VALIDATIONS END

  # ASSOCIATIONS START
  test "should have many change_logs" do
    assert_respond_to @place, :change_logs
  end

  test "should have many menus" do
    assert_respond_to @place, :menus
  end

  test "should have many images" do
    assert_respond_to @place, :images
  end

  test "should have many tags" do
    assert_respond_to @place, :tags
  end

  test "should have many reviews" do
    assert_respond_to @place, :reviews
  end

  # ASSOCIATIONS END

  # METHODS & CALLBACKS START
  test "featured_image should return first image path" do
    @place.save
    file1 = fixture_file_upload("test.png")
    fixture_file_upload("test2.png")

    @place.images.attach(file1)
    assert_equal Rails.application.routes.url_helpers.rails_blob_path(@place.images.first, only_path: true),
                 @place.featured_image
  end

  test "featured_image should return nil if no images attached" do
    assert_nil @place.featured_image
  end

  test "approve should set approved to true" do
    @place.approve
    assert @place.approved
  end

  test "should add error if image type is invalid" do
    file = fixture_file_upload("test.gif")
    @place.images.attach(file)
    assert_not @place.valid?
    assert_equal I18n.t("activerecord.attributes.place.image_invalid"), @place.errors[:images].first
  end

  test "should add error if more than 10 images" do
    11.times do
      file = fixture_file_upload("test.png")
      @place.images.attach(file)
    end
    assert_not @place.valid?
    assert_equal I18n.t("max_image_limit", count: 10), @place.errors[:images].first
  end

  test "should add error if image size is more than 3mb" do
    file = fixture_file_upload("testbig.jpeg", "image/jpeg")
    @place.images.attach(file)
    assert_not @place.valid?
    assert_equal I18n.t("activerecord.attributes.place.image_size_invalid"), @place.errors[:images].first
  end

  # METHODS & CALLBACKS END

  # SCOPES START
  test "should return approved places" do
    @place.approve
    @place.save
    assert_includes Place.approved, @place
  end

  test "should not return unapproved places" do
    @place.save
    assert_not_includes Place.approved, @place
  end

  test "should return places with name like" do
    @place.save
    assert_includes Place.filter_by_name("Test"), @place
  end

  test "should not return places with name not like" do
    @place.save
    assert_not_includes Place.filter_by_name("Test2"), @place
  end
  # SCOPES END
end
# rubocop:enable Metrics/ClassLength
