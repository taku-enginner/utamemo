require "test_helper"

class MemoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get memo_index_url
    assert_response :success
  end

  test "should get show" do
    get memo_show_url
    assert_response :success
  end

  test "should get create" do
    get memo_create_url
    assert_response :success
  end

  test "should get update" do
    get memo_update_url
    assert_response :success
  end

  test "should get destroy" do
    get memo_destroy_url
    assert_response :success
  end
end
