require "application_system_test_case"

class LineItemsTest < ApplicationSystemTestCase
  test "line item should have line-item-highlight class" do
    visit store_index_url

    click_on "Add to Cart", match: :first

    assert page.has_css? "table tbody tr.line-item-highlight"
  end
end
