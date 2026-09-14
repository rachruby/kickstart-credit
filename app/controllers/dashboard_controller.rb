class DashboardController < ApplicationController
  def show
    @accounts      = current_user.credit_accounts.includes(:payments)
    @open_disputes = current_user.disputes.open_disputes.order(created_at: :desc)
    @score_entries = current_user.score_entries.limit(6).reverse
    @score_goal    = current_user.score_goal
    @tips          = CreditCoach.new(current_user).tips
  end
end
