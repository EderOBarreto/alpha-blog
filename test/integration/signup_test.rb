require "test_helper"

class SignupTest < ActionDispatch::IntegrationTest

  setup do
    @user_params = { username: "johndoe", email: "johndoe@example.com", password: "password" }
  end 

  test "get into signup form and create an account" do
    get "/signup"
    assert_response :success
    assert_difference "User.count", 1 do
      post users_path, params: { user: @user_params }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "Listing all articles", response.body
  end

  test "get into signup form and reject empty form" do
    get "/signup"
    assert_response :success
    assert_no_difference "User.count" do
      post users_path, params: { user: { username: "", email: "", password: "" } }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
    assert_select "h4.alert-heading"
  end
end
