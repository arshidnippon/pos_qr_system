# app/helpers/application_helper.rb
module ApplicationHelper
    def auth_page?
      controller_name.in?(%w[sessions registrations passwords confirmations unlocks]) &&
      devise_controller?
    end
  end
  