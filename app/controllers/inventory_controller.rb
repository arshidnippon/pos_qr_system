class InventoryController < ApplicationController
  def scan
    @product = Product.find_by(sku: params[:sku]) if params[:sku].present?
  end

  def sell
    product = Product.find_by(sku: params[:sku])

    if product && product.quantity > 0
      product.quantity -= 1

      Sale.transaction do
        product.save!   # persist quantity update
        Sale.create!(product: product, quantity: 1)
      end

      flash[:notice] = "✅ #{product.name} marked as sold. Inventory updated."

      # 🧠 Calculate stock percentage
      percent_left = (product.quantity.to_f / product.initial_stock.to_f) * 100

      # ⚠️ 1. Show Flash Alert
      if percent_left <= 20
        flash[:alert] = "⚠️ Low stock alert: only #{product.quantity} left!"

        # 📧 2. Send Low Stock Email once
        unless product.low_stock_email_sent
          ProductMailer.low_stock_email(product).deliver_later
          product.update_column(:low_stock_email_sent, true)
        end
      elsif percent_left > 50 && product.low_stock_email_sent
        # ♻️ 3. Reset the flag if stock is replenished above 50%
        product.update_column(:low_stock_email_sent, false)
      end

      redirect_to dashboard_index_path
    else
      redirect_to inventory_scan_path, alert: "❌ Product not found or out of stock."
    end
  end
end
