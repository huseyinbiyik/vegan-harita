require "application_system_test_case"

class ReviewsTest < ApplicationSystemTestCase
  setup do
    @place = places(:one)
    @place.approve
    @place.save
  end

  test "adding review" do
    user = users(:one)
    sign_in user

    visit place_url(@place)

    click_on "Write a review"

    find("label", text: "5", visible: false).click
    fill_in "review_content", with: "Great place"
    fill_in "review_feedback", with: "I love this place but it is between us"

    click_on "Submit"
    page.driver.browser.switch_to.alert.accept

    assert_text "Review sent successfully. Thank you for your contribution! 💚"
    assert_equal "Great place", @place.reviews.last.content
  end

  # TODO: Add test for editing review
end
