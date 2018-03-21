require 'test_helper'

class ChartControllerTest < ActionDispatch::IntegrationTest
  test "should get graph" do
    get chart_graph_url
    assert_response :success
  end

end
