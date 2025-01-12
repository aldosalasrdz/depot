class AddPaymentTypeInfoToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :routing_number, :string, null: true
    add_column :orders, :account_number, :string, null: true
    add_column :orders, :credit_cart_number, :string, null: true
    add_column :orders, :expiration_date, :string, null: true
    add_column :orders, :po_number, :string, null: true
  end
end
