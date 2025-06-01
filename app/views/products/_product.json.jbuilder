json.extract! product, :id, :name, :sku, :quantity, :expire_date, :created_at, :updated_at
json.url product_url(product, format: :json)
