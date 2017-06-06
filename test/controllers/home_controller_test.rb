require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get topPane" do
    get home_topPane_url
    assert_response :success
  end

end
