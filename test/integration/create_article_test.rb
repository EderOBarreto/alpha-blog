require "test_helper"

class CreateArticleTest < ActionDispatch::IntegrationTest

  setup do
    @user = User.create(username: "johndoe", email: "johndoe@example.com", password: "password")
    sign_in_as(@user)
  end

  test "get new article and create an article" do
    get '/articles/new'
    assert_response :success
    assert_difference "Article.count", 1 do 
      post articles_path, params: { article: { title: "This is a test", description: "This is the article description" } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "This is a test", response.body
  end

  test "get new article and reject empty form submission" do
    get '/articles/new'
    assert_response :success
    assert_no_difference "Article.count" do 
      post articles_path, params: { article: { title: "", description: "" } }
    end
    assert_match "errors", response.body
    assert_select "div.alert"
    assert_select "h4.alert-heading"
  end

end
