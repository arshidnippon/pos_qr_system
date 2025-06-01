class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Redirect to login page after logout
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
