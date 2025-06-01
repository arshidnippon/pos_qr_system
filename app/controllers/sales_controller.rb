class SalesController < ApplicationController
  def index
    @products = Product.all
    @sales = Sale.includes(:product).order(created_at: :desc)
  
    if params[:product_id].present?
      @sales = @sales.where(product_id: params[:product_id])
    end
  
    if params[:start_date].present? && params[:end_date].present?
      @sales = @sales.where(created_at: params[:start_date]..params[:end_date])
    end
  
    @sales = @sales.limit(100)
  end
  
  
end
