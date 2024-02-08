require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup do
    @review = reviews(:one)
  end

  teardown do
    @review = nil
  end

  test "should be valid" do
    assert @review.valid?
  end

  # ASSOCIATIONS START
  test "should belong to place" do
    assert @review.place
  end

  test "should belong to user" do
    assert @review.user
  end

  test "should have many attached images" do
    assert @review.images
  end
  # ASSOCIATIONS END

  # VALIDATIONS START
  test "rating should be present" do
    @review.rating = nil
    assert_not @review.valid?
  end

  test "rating should be an integer" do
    @review.rating = 1.5
    assert_not @review.valid?
  end

  test "rating should be greater than or equal to 1" do
    @review.rating = 0
    assert_not @review.valid?
  end

  test "rating should be less than or equal to 5" do
    @review.rating = 6
    assert_not @review.valid?
  end

  test "content should be present" do
    @review.content = "     "
    assert_not @review.valid?
  end

  test "content should not be too short" do
    @review.content = "a" * 4
    assert_not @review.valid?
  end

  test "content should not be too long" do
    @review.content = "a" * 501
    assert_not @review.valid?
  end

  test "feedback should not be too long" do
    @review.feedback = "a" * 501
    assert_not @review.valid?
  end
  # VALIDATIONS END
  # CUSTOM VALIDATIONS START
  test "should have at most 5 images" do
    @review.images.attach([ fixture_file_upload(Rails.root.join("test", "fixtures", "files", "test.png")) ] * 6)
    assert_not @review.valid?
  end

  test "each image should be at most 3MB" do
    @review.images.attach(fixture_file_upload(Rails.root.join("test", "fixtures", "files", "test.png")))
    @review.images.attach(fixture_file_upload(Rails.root.join("test", "fixtures", "files", "test.png")))
    @review.images.attach(fixture_file_upload(Rails.root.join("test", "fixtures", "files", "test.png")))
    @review.images.attach(fixture_file_upload(Rails.root.join("test", "fixtures", "files", "test.png")))
    @review.images.attach(fixture_file_upload(Rails.root.join("test", "fixtures", "files", "test.png")))
    @review.images.attach(fixture_file_upload(Rails.root.join("test", "fixtures", "files", "test.png")))
    assert_not @review.valid?
  end

  test "images under 3MB should be valid" do
    @review.images.attach(fixture_file_upload(Rails.root.join("test", "fixtures", "files", "test.png")))
    assert @review.valid?
  end
  # CUSTOM VALIDATIONS END

  test "should approve" do
    @review.approve
    assert @review.approved
  end
end
