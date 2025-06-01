class ReportsController < ApplicationController
  def sales
    @daily_sales = Sale.group_by_day(:created_at).sum(:quantity)
    @monthly_sales = Sale.group_by_month(:created_at).sum(:quantity)
    @yearly_sales = Sale.group_by_year(:created_at).sum(:quantity)
  end
end
