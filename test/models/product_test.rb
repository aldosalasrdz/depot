require "test_helper"

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new

    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "My Book Title",
                          description: "A simple book",
                          image_url: "cover.png")

    product.price = -1
    assert product.invalid?
    assert_equal [ "must be greater than or equal to 0.01" ],
      product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal [ "must be greater than or equal to 0.01" ],
      product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title: "My Book Title",
                description: "A simple book",
                price: 1,
                image_url: image_url)
  end

  test "image url must be valid" do
    ok = %w[fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif ]

    bad = %w[fred.doc fred.gif/more fred.gif.more ]

    ok.each do |image_url|
      assert new_product(image_url).valid?,
             "#{image_url} must be valid"
    end

    bad.each do |image_url|
      assert new_product(image_url).invalid?,
             "#{image_url} must be invalid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "A simple book",
                          price: 1,
                          image_url: "fred.gif")

    assert product.invalid?
    assert_equal [ "already in use, try another one." ], product.errors[:title]
  end

  test "title must be at least 10 characters" do
    product = Product.new(description: "A simple book",
                          price: 1,
                          image_url: "fred.gif")
    product.title = "My Book"
    assert product.invalid?
    assert_equal [ "is too short (minimum is 10 characters)" ], product.errors[:title]

    product.title = "Programming Ruby 3.3"
    assert product.valid?
  end
end
