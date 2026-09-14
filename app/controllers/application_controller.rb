class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  # Single-user demo: no auth. In production this becomes a real
  # session lookup (has_secure_password or Devise).
  def current_user
    @current_user ||= User.first ||
                      User.create!(name: "Demo User", email: "demo@kickstart.dev")
  end
end
