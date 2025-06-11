class AddLowStockEmailSentToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :low_stock_email_sent, :boolean, default: false, null: false
  end
end
