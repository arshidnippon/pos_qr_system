class InventoryController < ApplicationController
  def scan
    @product = Product.find_by(sku: params[:sku]) if params[:sku].present?
  end

  def sell
    product = Product.find_by(sku: params[:sku])
  
    if product && product.quantity > 0
      product.quantity -= 1
  
      Sale.transaction do
        product.save!   # triggers check_low_stock callback
        Sale.create!(product: product, quantity: 1)
      end
  
      flash[:notice] = "✅ #{product.name} marked as sold. Inventory updated."
  
      percent_left = (product.quantity.to_f / product.initial_stock.to_f) * 100
      flash[:alert] = "⚠️ Low stock alert: only #{product.quantity} left!" if percent_left <= 20
  
      redirect_to dashboard_index_path
    else
      redirect_to inventory_scan_path, alert: "❌ Product not found or out of stock."
    end
  end
  
  
end
