class ProductMailer < ApplicationMailer
    def low_stock_email(product)
      @product = product
      mail(to: "admin@example.com", subject: "Low Stock Alert: #{product.name}")
    end
  end
  