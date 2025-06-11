class ProductMailer < ApplicationMailer
  def low_stock_email(product)
    @product = product
    mail(to: product.alert_email, subject: "Low Stock Alert for #{@product.name}")
  end
end
