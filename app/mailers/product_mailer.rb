class ProductMailer < ApplicationMailer
  def low_stock_email(product)
    @product = product
    mail(to: product.alert_email || "admin@example.com", subject: "Low Stock Alert: #{product.name}")
  end
end
