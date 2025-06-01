class Product < ApplicationRecord
    has_many :sales, dependent: :destroy
    after_update :check_low_stock

    def check_low_stock
      if quantity_previously_changed? && quantity < 50 && quantity >= 20
        ProductMailer.low_stock_email(self).deliver_later
      end
    end
    
end
