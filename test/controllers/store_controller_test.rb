require "test_helper"

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get store_index_url
    assert_response :success
    assert_select "nav a", minimum: 4
    assert_select "main ul li", 3
    assert_select "h2", "Programming Ruby 1.9"

    # Verify that at least one <div> element contains a monetary value
    # formatted as "$1,234.56" (with a dollar sign, commas, and two decimals).
    assert_select "div", /\$[,\d]+\.\d\d/
  end
end
