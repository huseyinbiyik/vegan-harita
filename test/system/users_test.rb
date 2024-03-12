require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    ActionMailer::Base.deliveries.clear
  end

  test "signing up" do
    visit new_user_registration_url

    fill_in "Username", with: "test"
    fill_in "E-mail", with: "test@case.com"
    fill_in "Password", with: "password"
    fill_in "Password Confirmation", with: "password"
    check "I read and accept the User Agreement"

    click_on "Sign up"

    assert_text "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account"

    assert_equal 1, ActionMailer::Base.deliveries.size

    email = ActionMailer::Base.deliveries.last

    assert_equal [ "test@case.com" ], email.to

    assert_match "Confirm My Account", email.body.encoded

    user = User.last

    assert_not user.confirmed?

    visit user_confirmation_path(confirmation_token: user.confirmation_token)

    assert_text "Your email address has been successfully confirmed."

    assert user.reload.confirmed?
  end

  test "getting confirmation email resent and confirming" do
    user = users(:two)

    assert_not user.confirmed?

    visit new_user_confirmation_path

    fill_in "E-mail", with: user.email

    click_on "Submit"

    user.reload

    assert_text "You will receive an email with instructions for how to confirm your email address in a few minutes."

    assert_equal 1, ActionMailer::Base.deliveries.size

    email = ActionMailer::Base.deliveries.last

    assert_equal [ user.email ], email.to

    assert_match "Confirm My Account", email.body.encoded

    visit user_confirmation_path(confirmation_token: user.confirmation_token)

    assert_text "Your email address has been successfully confirmed."
  end


  test "logging in" do
    User.create!(username: "testuser", email: "test@example.com", password: "password", confirmed_at: Time.now)

    visit new_user_session_path

    fill_in "E-mail", with: "test@example.com"
    fill_in "Password", with: "password"

    click_on "Log in"

    assert_text "Welcome! 👋"
  end

  test "logging out" do
    User.create!(username: "testuser", email: "test@example.com", password: "password", confirmed_at: Time.now)

    visit new_user_session_path

    fill_in "E-mail", with: "test@example.com"
    fill_in "Password", with: "password"

    click_on "Log in"

    sleep 3

    find("#account-icon").hover

    click_on "Log Out"

    assert_text "Signed out successfully."
  end

  test "forgetting password" do
    user = users(:one)

    visit new_user_session_path

    click_on "Forgot my password"

    fill_in "E-mail", with: user.email

    click_on "Change my password"

    assert_text "You will receive an email with instructions on how to reset your password in a few minutes."

    assert_equal 1, ActionMailer::Base.deliveries.size

    email = ActionMailer::Base.deliveries.last

    assert_equal [ "user@example.com" ], email.to

    assert_match "Change My Password", email.body.encoded
  end

  test "resetting password" do
    user = users(:one)

    # Request a password reset
    raw, enc = Devise.token_generator.generate(User, :reset_password_token)
    user.reset_password_token   = enc
    user.reset_password_sent_at = Time.now.utc
    user.save(validate: false)

    visit edit_user_password_path(reset_password_token: raw)

    fill_in "New password", with: "newpassword"
    fill_in "Confirm new password", with: "newpassword"

    click_on "Change my password"
    assert_text "Your password has been changed successfully. You are now signed in."
  end
end
