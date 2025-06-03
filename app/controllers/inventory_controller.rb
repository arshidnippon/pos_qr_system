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

      flash[:notice] = "✅ #{product.name} marked as sold. Inventory updated."

      if product.quantity < 20
        flash[:alert] = "⚠️ Stock very low: only #{product.quantity} remaining!"
      end

      flash[:notice] = "✅ Product marked as sold. Inventory updated."
      redirect_to dashboard_index_path
    else
      redirect_to inventory_scan_path, alert: "❌ Product not found or out of stock."
    end
  end
end
