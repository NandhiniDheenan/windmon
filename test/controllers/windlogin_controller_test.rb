require 'test_helper'

class WindloginControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get windlogin_login_url
    assert_response :success
  end

end
