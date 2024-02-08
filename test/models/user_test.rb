require "test_helper"

class UserTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup do
    @user = users(:one)
  end

  teardown do
    @user = nil
  end

  # ENUMS START
  test "should define role enum" do
    assert_equal({ "user" => 0, "admin" => 1 }, User.roles)
  end
  # ENUMS END

  # ASSOCIATIONS START
  test "should have many change_logs" do
    assert @user.change_logs
  end

  test "should have many menus" do
    assert @user.menus
  end

  test "should have many reviews" do
    assert @user.reviews
  end

  test "should have many likes" do
    assert @user.likes
  end

  test "should have one attached avatar" do
    assert @user.avatar
  end
  # ASSOCIATIONS END

  # VALIDATIONS START
  test "should validate inclusion of locale" do
    user = User.new(locale: "invalid")
    assert_not user.valid?
    assert_equal [ "is not included in the list" ], user.errors[:locale]
  end

  test "should validate acceptance of user_agreement_accepted" do
    user = User.new(user_agreement_accepted: false)
    assert_not user.valid?
    assert_equal [ "You must accept the User Agreement" ], user.errors[:user_agreement_accepted]
  end

  test "should validate presence of username" do
    @user.username = ""
    @user.save
    assert_not @user.valid?
    assert_equal [ "can't be blank", "is invalid" ], @user.errors[:username]
  end

  test "should validate uniqueness of username" do
    user = users(:two)
    user.username = users(:one).username
    assert_not user.valid?
    assert_equal [ "has already been taken" ], user.errors[:username]
  end

  test "should validate length of username" do
    user = User.new(username: "a" * 21)
    assert_not user.valid?
    assert_equal [ "is too long (maximum is 20 characters)" ], user.errors[:username]
  end

  test "should validate format of username" do
    user = User.new(username: "invalid_username!")
    assert_not user.valid?
    assert_equal [ "is invalid" ], user.errors[:username]
  end

  test "should validate avatar file type" do
    @user.avatar.attach(io: File.open(Rails.root.join("test", "fixtures", "files", "test.gif")), filename: "test.gif", content_type: "image/gif")
    assert_not @user.valid?
    assert_equal [ "Incorrect file format! Only jpg and png types are acceptable." ], @user.errors[:avatar]
  end

  test "should validate username is not a route" do
    Rails.application.routes.draw do
      get "existing" => "test#action"
    end

    user = users(:two)
    user.username = "existing"
    user.save
    assert_not user.valid?
    assert_equal [ "is not allowed. Please try another one." ], user.errors[:username]

    Rails.application.reload_routes!
  end
  # VALIDATIONS END

  # SCOPES START
  test "should return approved users" do
    approved_users = User.approved
    assert approved_users.all?(&:approved)
  end
  # SCOPES END

  # PUBLIC INSTANCE METHODS START
  test "should approve user" do
    @user.approve
    assert @user.approved
  end

  test "should check if user is admin" do
    assert_not @user.admin?
    @user.role = "admin"
    assert @user.admin?
  end
  # PUBLIC INSTANCE METHODS END
end
