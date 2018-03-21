require 'test_helper'

class WindmonControllerTest < ActionDispatch::IntegrationTest
  test "should get wind" do
    get windmon_wind_url
    assert_response :success
  end

end
