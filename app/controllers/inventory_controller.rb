class InventoryController < ApplicationController
  def scan
    @product = Product.find_by(sku: params[:sku]) if params[:sku].present?
  end

  def sell
    product = Product.find_by(sku: params[:sku])

    if product && product.quantity > 0
      product.quantity -= 1

      Sale.transaction do
        product.save!
        Sale.create!(product: product, quantity: 1)
      end

      percent_left = (product.quantity.to_f / product.initial_stock.to_f) * 100

      if percent_left <= 50 && product.alert_email.present?
        ProductMailer.low_stock_email(product).deliver_later
      end

      flash[:notice] = "✅ #{product.name} marked as sold. Inventory updated."
      flash[:alert] = "⚠️ Low stock alert: only #{product.quantity} left!" if percent_left <= 20

      redirect_to dashboard_index_path
    else
      redirect_to inventory_scan_path, alert: "❌ Product not found or out of stock."
    end
  end
end
