require "test_helper"

class FocusControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get focus_index_url
    assert_response :success
  end
end
