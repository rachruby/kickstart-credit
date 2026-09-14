class ScoreGoal < ApplicationRecord
  belongs_to :user

  validates :target_score, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 300,
    less_than_or_equal_to: 850
  }
  validates :target_date, presence: true

  def points_remaining
    current = user.latest_score
    return nil if current.nil?

    [target_score - current, 0].max
  end
end
