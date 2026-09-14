require "test_helper"

class DisputeTest < ActiveSupport::TestCase
  test "submit! generates a letter and stamps the date" do
    dispute = disputes(:draft_dispute)
    dispute.submit!

    assert dispute.submitted?
    assert_equal Date.current, dispute.submitted_on
    assert_includes dispute.letter_body, "Equifax"
    assert_includes dispute.letter_body, "Fair Credit Reporting Act"
    assert_includes dispute.letter_body, dispute.item_description
  end

  test "submit! refuses non-draft disputes" do
    dispute = disputes(:draft_dispute)
    dispute.submit!
    assert_raises(ArgumentError) { dispute.submit! }
  end

  test "resolve! validates the outcome" do
    dispute = disputes(:draft_dispute)
    dispute.submit!
    assert_raises(ArgumentError) { dispute.resolve!(outcome: "shredded") }

    dispute.resolve!(outcome: "resolved", notes: "Item deleted")
    assert dispute.resolved?
    assert_equal "Item deleted", dispute.resolution_notes
  end

  test "rejects unknown bureaus" do
    dispute = Dispute.new(
      user: users(:demo), bureau: "Craigslist",
      item_description: "x", reason: "Not my account"
    )
    assert_not dispute.valid?
  end
end
