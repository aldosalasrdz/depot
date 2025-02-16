require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper
  test "check dynamic fields" do
    visit store_index_url

    click_on "Add to Cart", match: :first

    click_on "Checkout"

    assert has_no_field? "Routing number"
    assert has_no_field? "Account number"
    assert has_no_field? "Credit card number"
    assert has_no_field? "Expiration date"
    assert has_no_field? "Po number"

    select "Check", from: "Pay with"

    assert has_field? "Routing #"
    assert has_field? "Account #"
    assert has_no_field? "CC #"
    assert has_no_field? "Expiry"
    assert has_no_field? "PO #"

    select "Credit Card", from: "Pay with"

    assert has_no_field? "Routing #"
    assert has_no_field? "Account #"
    assert has_field? "CC #"
    assert has_field? "Expiry"
    assert has_no_field? "PO #"

    select "Purchase Order", from: "Pay with"

    assert has_no_field? "Routing #"
    assert has_no_field? "Account #"
    assert has_no_field? "CC #"
    assert has_no_field? "Expiry"
    assert has_field? "PO #"
  end

  test "add to cart should create a cart" do
    visit store_index_url

    click_on "Add to Cart", match: :first

    assert has_text? "Your Cart"
  end


  test "empty cart should delete the cart" do
    visit store_index_url

    click_on "Add to Cart", match: :first
    click_on "Empty Cart"

    assert has_no_text? "Your Cart"
  end

  test "check order and delivery" do
    LineItem.delete_all
    Order.delete_all

    visit store_index_url

    click_on "Add to Cart", match: :first

    click_on "Checkout"

    fill_in "Name", with: "Dave Thomas"
    fill_in "Address", with: "123 Main Street"
    fill_in "Email", with: "dave@example.com"

    select "Check"
    fill_in "Routing #", with: "123456"
    fill_in "Account #", with: "987654"

    click_button "Place order"
    assert_text "Thank you for your order"

    perform_enqueued_jobs
    perform_enqueued_jobs
    assert_performed_jobs 2

    orders = Order.all
    assert_equal 1, orders.size

    order = orders.first
    assert_equal "Dave Thomas", order.name
    assert_equal "123 Main Street", order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check", order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal [ "dave@example.com" ], mail.to
    assert_equal "Sam Ruby <depot@example.com>", mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end
end
