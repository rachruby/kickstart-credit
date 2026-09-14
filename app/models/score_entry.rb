class ScoreEntry < ApplicationRecord
  belongs_to :user

  validates :score, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 300,
    less_than_or_equal_to: 850
  }
  validates :recorded_on, presence: true, uniqueness: { scope: :user_id }
end
