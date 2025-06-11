class Product < ApplicationRecord
  has_many :sales, dependent: :destroy

  # Ensure you have a migration adding this boolean with default false
  # e.g., t.boolean :low_stock_email_sent, default: false, null: false
  after_update :check_low_stock

  def check_low_stock
    return unless saved_change_to_quantity?

    if quantity < 50 && quantity >= 20 && !low_stock_email_sent
      ProductMailer.low_stock_email(self).deliver_later
      update_column(:low_stock_email_sent, true)

      if alert_user
        notif = alert_user.notifications.create!(
          message: "Low stock alert: Only #{quantity} units left for #{name}.",
          read: false
        )
        Rails.logger.info "Notification created: #{notif.inspect}"
      else
        Rails.logger.info "Alert user not found for email: #{alert_email}"
      end

    elsif quantity >= 50 && low_stock_email_sent
      reset_low_stock_email_flag!
    end
  end

  def reset_low_stock_email_flag!
    update_column(:low_stock_email_sent, false)
  end

  def alert_user
    User.find_by(email: alert_email)
  end
end
