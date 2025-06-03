require "csv"

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

    respond_to do |format|
      format.html
      format.csv do
        headers["Content-Disposition"] = "attachment; filename=sales_report.csv"
        headers["Content-Type"] = "text/csv"
        render plain: generate_csv(@sales)
      end
    end
  end

  private

  def generate_csv(sales)
    CSV.generate(headers: true) do |csv|
      csv << ["Date", "Product", "Quantity"]
      sales.each do |sale|
        csv << [sale.created_at.strftime("%Y-%m-%d %H:%M"), sale.product.name, sale.quantity]
      end
    end
  end
end
