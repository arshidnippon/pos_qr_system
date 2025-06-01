class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :sku
      t.integer :quantity
      t.date :expire_date

      t.timestamps
    end
  end
end
