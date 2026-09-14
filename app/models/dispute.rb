class Dispute < ApplicationRecord
  BUREAUS  = %w[Equifax Experian TransUnion].freeze
  REASONS  = [
    "Not my account",
    "Incorrect balance",
    "Incorrect payment status",
    "Duplicate entry",
    "Account closed but reported open",
    "Identity theft"
  ].freeze

  belongs_to :user

  enum :status, {
    draft:        "draft",
    submitted:    "submitted",
    under_review: "under_review",
    resolved:     "resolved",
    rejected:     "rejected"
  }

  validates :bureau, inclusion: { in: BUREAUS }
  validates :item_description, presence: true
  validates :reason, inclusion: { in: REASONS }

  scope :open_disputes, -> { where(status: %w[draft submitted under_review]) }

  def submit!
    raise ArgumentError, "only drafts can be submitted" unless draft?

    update!(status: "submitted", letter_body: generate_letter, submitted_on: Date.current)
  end

  def resolve!(outcome:, notes: nil)
    unless %w[resolved rejected].include?(outcome)
      raise ArgumentError, "outcome must be resolved or rejected"
    end

    update!(status: outcome, resolution_notes: notes, resolved_on: Date.current)
  end

  # Deterministic template for the demo. In production this is exactly
  # where an LLM call would slot in to draft a personalized letter from
  # the user's report data — which is what Kikoff's AI Credit Disputes
  # feature does. Keeping the interface identical (a method returning
  # letter text) means swapping in the AI is a one-line change here.
  def generate_letter
    <<~LETTER
      To: #{bureau} Dispute Department
      Date: #{Date.current.strftime('%B %-d, %Y')}

      Re: Formal dispute of inaccurate information

      To whom it may concern,

      I am writing to dispute the following item on my credit report:

        Item:   #{item_description}
        Reason: #{reason}

      Under the Fair Credit Reporting Act (15 U.S.C. § 1681i), I request
      that you investigate this item and correct or delete it within 30
      days. Please send written confirmation of the outcome.

      Sincerely,
      #{user.name}
    LETTER
  end
end
