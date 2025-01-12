require "application_system_test_case"

class CartsTest < ApplicationSystemTestCase
  test "add to cart should create a cart" do
    visit store_index_url

    click_on "Add to Cart", match: :first

    assert has_text? "Your Cart"
  end


  test "empty cart should delete the cart" do
    visit store_index_url

    click_on "Add to Cart", match: :first
    click_on "Empty cart"

    assert has_no_text? "Your Cart"
  end
end
