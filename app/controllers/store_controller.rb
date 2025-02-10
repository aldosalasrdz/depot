class StoreController < ApplicationController
  include CurrentCart

  before_action :set_cart
  skip_before_action :authorize

  def index
    @products = Product.order(:title)

    respond_to do |format|
      format.html
      format.json { render json: @products }
    end
  end
end
