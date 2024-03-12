require "application_system_test_case"

class PlacesTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit places_url
    assert_selector "h3", text: "Last Added Places"
    assert_text "veganharita"
  end

  test "adding places without login should not be allowed" do
    visit new_place_url
    assert_text "You need to sign in or sign up before continuing."
    assert_selector "h1", text: "Log In"
  end

  test "adding places with login should be allowed" do
    user = users(:one)
    sign_in user

    visit new_place_url
    fill_in "Name", with: "Anıtkabir"
    select "Vegan", from: "place_vegan"
    fill_in "instagram-input", with: "veganharita"
    fill_in "facebook-input", with: "veganharita"
    fill_in "x-input", with: "veganharita"
    fill_in "website-input", with: "veganharita.com"
    fill_in "place_email", with: "iletisim@veganharita.com"
    fill_in "place_phone", with: "2121112233"
    fill_in "Address", with: "Anıtkabir"
    sleep 1
    find(".pac-item", match: :first).click
    sleep 1


    click_on "Submit"
    assert_text "Place suggestion sent successfully. Thank you for your contribution! 💚"

    place = Place.find_by(name: "Anıtkabir")
    assert_not_nil place
    assert_equal false, place.approved

    place.approve
    place.save

    visit place_url(place)
    assert_text "Anıtkabir"
    assert_text "veganharita"
    assert_text "Vegan"
    assert_link "Directions", href: "https://www.google.com/maps/dir/?api=1&destination=#{place.latitude},#{place.longitude}"
    assert_link "Call", href: "tel: 02121112233"
    assert_link "veganharita", href: "https://www.instagram.com/veganharita"
    assert_link "veganharita", href: "https://www.facebook.com/veganharita"
    assert_link "veganharita", href: "https://www.x.com/veganharita"
    assert_link "veganharita.com", href: "https://veganharita.com"

    Place.find_by(name: "Anıtkabir").destroy
  end

  test "editing places" do
    place = places(:one)
    place.update(approved: true)
    user = users(:one)

    sign_in user

    visit place_url(place)
    click_on "Suggest an Edit"

    # Turbo frame id
    find("#name").click
    fill_in "change_log[name]", with: "Anıtkabir"
    click_on "Submit"
    # For the alert box, it is just accepting.
    page.driver.browser.switch_to.alert.accept
    assert_text "Place edit request sent successfully. Thank you for your contribution! 💚"

    find("#vegan").click
    select "Vegan Option", from: "change_log_vegan"
    click_on "Submit"
    page.driver.browser.switch_to.alert.accept
    assert_text "Place edit request sent successfully. Thank you for your contribution! 💚"

    find("#location").click
    sleep 1
    fill_in "change_log[address]", with: "Anıtkabir"
    find(".pac-item", match: :first).click
    click_on "Submit"
    page.driver.browser.switch_to.alert.accept
    assert_text "Place edit request sent successfully. Thank you for your contribution! 💚"

    find("#phone").click
    fill_in "change_log[phone]", with: "2121112233"
    click_on "Submit"
    page.driver.browser.switch_to.alert.accept
    assert_text "Place edit request sent successfully. Thank you for your contribution! 💚"

    find("#tags").click
    check "Breakfast"
    click_on "Submit"
    page.driver.browser.switch_to.alert.accept
    assert_text "Place edit request sent successfully. Thank you for your contribution! 💚"


    find("turbo-frame#instagram a.edit-button").click
    fill_in "change_log[instagram_handle]", with: "veganharita"
    click_on "Submit"
    page.driver.browser.switch_to.alert.accept
    assert_text "Place edit request sent successfully. Thank you for your contribution! 💚"

    find("turbo-frame#facebook a.edit-button").click
    fill_in "change_log[facebook_handle]", with: "veganharita"
    click_on "Submit"
    page.driver.browser.switch_to.alert.accept
    assert_text "Place edit request sent successfully. Thank you for your contribution! 💚"

    find("turbo-frame#x a.edit-button").click
    fill_in "change_log[x_handle]", with: "veganharita"
    click_on "Submit"
    page.driver.browser.switch_to.alert.accept

    find("turbo-frame#web a.edit-button").click
    fill_in "change_log[web_url]", with: "veganharita.com"
    click_on "Submit"
    page.driver.browser.switch_to.alert.accept
    assert_text "Place edit request sent successfully. Thank you for your contribution! 💚"

    place.reload
    assert_not_equal "Anıtkabir", place.name
    assert_not_equal "Vegan", place.vegan
    assert_not_equal "Anıtkabir", place.address
    assert_not_equal "2121112233", place.phone
    assert_not_equal "veganharita", place.instagram_handle
    assert_not_equal "veganharita", place.facebook_handle
    assert_not_equal "veganharita", place.x_handle
    assert_not_equal "veganharita.com", place.web_url



    place.change_logs.each do |change_log|
      change_log.approve_place_edit
    end


    place.reload


    visit place_url(place)
    assert_text "Anıtkabir"
    assert_text "Vegan Option"
    assert_link "Directions", href: "https://www.google.com/maps/dir/?api=1&destination=#{place.latitude},#{place.longitude}"
    assert_link "Call", href: "tel: 02121112233"
    assert_text "Breakfast"
    assert_link "veganharita", href: "https://www.instagram.com/veganharita"
    assert_link "veganharita", href: "https://www.facebook.com/veganharita"
    assert_link "veganharita", href: "https://www.x.com/veganharita"
    assert_link "veganharita.com", href: "https://veganharita.com"
  end
end
