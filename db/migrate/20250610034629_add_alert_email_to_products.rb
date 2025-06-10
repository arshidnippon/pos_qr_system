class AddAlertEmailToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :alert_email, :string
  end
end
