require "application_system_test_case"

class MenusTest < ApplicationSystemTestCase
  setup do
    @place = places(:one)
    @place.approve
    @place.save
  end

  test "adding menu" do
    user = users(:one)
    sign_in user

    visit place_url(@place)

    click_on "Suggest an Edit"

    click_on "Add Product"

    fill_in "menu_name", with: "Vegan Burger"
    fill_in "menu_description", with: "Delicious vegan burger"
    select "Dessert", from: "menu_product_category"
    fill_in "menu_price", with: "10"

    click_on "Submit"
    page.driver.browser.switch_to.alert.accept

    assert_text "Menu suggestion sent successfully. Thank you for your contribution! 💚"
    assert_equal "Vegan Burger", @place.menus.last.name
  end
end
