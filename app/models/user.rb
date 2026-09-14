class User < ApplicationRecord
  has_many :credit_accounts, dependent: :destroy
  has_many :payments, through: :credit_accounts
  has_many :disputes, dependent: :destroy
  has_many :score_entries, -> { order(recorded_on: :desc) }, dependent: :destroy
  has_one  :score_goal, dependent: :destroy

  validates :name,  presence: true
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  # Payment history is ~35% of a FICO score — the core thing a
  # credit-builder tradeline (like Kikoff's Credit Account) improves.
  def on_time_rate
    settled = payments.where.not(paid_on: nil)
    return nil if settled.empty?

    settled.where(status: "paid").count.fdiv(settled.count)
  end

  def latest_score
    score_entries.first&.score
  end
end
