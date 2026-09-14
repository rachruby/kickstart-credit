class CreditAccount < ApplicationRecord
  belongs_to :user
  has_many :payments, -> { order(due_on: :asc) }, dependent: :destroy

  enum :status, { active: "active", closed: "closed" }

  validates :name, presence: true
  validates :credit_limit_cents, numericality: { only_integer: true, greater_than: 0 }
  validates :balance_cents,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :opened_on, presence: true
  validate  :balance_within_limit

  # Utilization is ~30% of a FICO score; keeping it under 30% is the
  # classic credit-coach tip.
  def utilization
    return 0.0 if credit_limit_cents.zero?

    balance_cents.fdiv(credit_limit_cents)
  end

  def utilization_pct
    (utilization * 100).round(1)
  end

  private

  def balance_within_limit
    return if balance_cents.blank? || credit_limit_cents.blank?
    return if balance_cents <= credit_limit_cents

    errors.add(:balance_cents, "cannot exceed the credit limit")
  end
end
