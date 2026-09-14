# A rule-based stand-in for an AI credit coach (a nod to Kikoff's
# "Fynn"). Returns prioritized, human-readable tips from the user's
# actual data. Swapping the rules for an LLM prompt over the same
# inputs is the natural production evolution — the call site in the
# dashboard doesn't change.
class CreditCoach
  Tip = Struct.new(:severity, :message)

  def initialize(user)
    @user = user
  end

  def tips
    tips = []
    tips.concat(utilization_tips)
    tips.concat(payment_tips)
    tips.concat(score_tips)
    tips << Tip.new(:good, "You're on track — keep payments on time and utilization low.") if tips.empty?
    tips
  end

  private

  attr_reader :user

  def utilization_tips
    user.credit_accounts.active.filter_map do |account|
      next if account.utilization <= 0.3

      Tip.new(
        :warn,
        "#{account.name} is at #{account.utilization_pct}% utilization — " \
        "paying it below 30% is one of the fastest ways to lift your score."
      )
    end
  end

  def payment_tips
    tips = []
    overdue = user.payments.select(&:overdue?)
    if overdue.any?
      tips << Tip.new(:urgent, "You have #{overdue.size} overdue payment(s). " \
                               "Payments 30+ days late can be reported to bureaus.")
    end
    rate = user.on_time_rate
    if rate && rate < 1.0
      tips << Tip.new(:warn, "Your on-time payment rate is #{(rate * 100).round}%. " \
                             "Consider enabling autopay to protect your history.")
    end
    tips
  end

  def score_tips
    tips = []
    if user.score_entries.none? || user.score_entries.first.recorded_on < 30.days.ago
      tips << Tip.new(:info, "Log a fresh score check-in to keep your trend accurate.")
    end
    goal = user.score_goal
    if goal && (remaining = goal.points_remaining)&.positive?
      tips << Tip.new(:info, "#{remaining} points to your #{goal.target_score} goal " \
                             "by #{goal.target_date.strftime('%b %Y')}.")
    end
    tips
  end
end
