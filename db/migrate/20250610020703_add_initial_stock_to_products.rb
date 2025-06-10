class AddInitialStockToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :initial_stock, :integer
  end
end
