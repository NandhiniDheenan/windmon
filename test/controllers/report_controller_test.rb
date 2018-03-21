require 'test_helper'

class ReportControllerTest < ActionDispatch::IntegrationTest
  test "should get showreport" do
    get report_showreport_url
    assert_response :success
  end

end
