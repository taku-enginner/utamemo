require "test_helper"

class MusixmatchSearchControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get musixmatch_search_search_url
    assert_response :success
  end
end
