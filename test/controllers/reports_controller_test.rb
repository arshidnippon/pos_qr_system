require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get sales" do
    get reports_sales_url
    assert_response :success
  end
end
