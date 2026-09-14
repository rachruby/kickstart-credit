require "test_helper"

class CreditAccountTest < ActiveSupport::TestCase
  test "utilization is balance over limit" do
    account = credit_accounts(:builder)
    assert_in_delta 0.25, account.utilization, 0.001
    assert_equal 25.0, account.utilization_pct
  end

  test "balance cannot exceed limit" do
    account = credit_accounts(:builder)
    account.balance_cents = account.credit_limit_cents + 1
    assert_not account.valid?
    assert_includes account.errors[:balance_cents].join, "cannot exceed"
  end

  test "requires positive credit limit" do
    account = CreditAccount.new(
      user: users(:demo), name: "Bad", credit_limit_cents: 0,
      balance_cents: 0, opened_on: Date.current
    )
    assert_not account.valid?
  end
end
