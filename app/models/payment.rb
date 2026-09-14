class Payment < ApplicationRecord
  belongs_to :credit_account

  enum :status, { scheduled: "scheduled", paid: "paid", late: "late" }

  validates :amount_cents, numericality: { only_integer: true, greater_than: 0 }
  validates :due_on, presence: true

  scope :settled, -> { where.not(paid_on: nil) }

  # Mirrors how a credit-builder product records payment history that
  # gets furnished to the bureaus: on-time vs late is what matters.
  def mark_paid!(on: Date.current)
    update!(paid_on: on, status: on > due_on ? "late" : "paid")
  end

  def overdue?
    scheduled? && due_on < Date.current
  end
end
