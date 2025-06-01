require "test_helper"

class InventoryControllerTest < ActionDispatch::IntegrationTest
  test "should get scan" do
    get inventory_scan_url
    assert_response :success
  end
end
