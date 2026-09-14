require "test_helper"

class CreditAccountsControllerTest < ActionDispatch::IntegrationTest
  setup { @account = credit_accounts(:builder) }

  test "index renders" do
    get credit_accounts_url
    assert_response :success
  end

  test "creates an account with valid params" do
    assert_difference("CreditAccount.count") do
      post credit_accounts_url, params: { credit_account: {
        name: "New Line", credit_limit_cents: 50_000,
        balance_cents: 0, opened_on: Date.current, status: "active"
      } }
    end
    assert_redirected_to credit_account_url(CreditAccount.last)
  end

  test "rejects invalid params" do
    assert_no_difference("CreditAccount.count") do
      post credit_accounts_url, params: { credit_account: {
        name: "", credit_limit_cents: -5, balance_cents: 0, opened_on: Date.current
      } }
    end
    assert_response :unprocessable_entity
  end

  test "updates an account" do
    patch credit_account_url(@account), params: { credit_account: { name: "Renamed" } }
    assert_redirected_to credit_account_url(@account)
    assert_equal "Renamed", @account.reload.name
  end

  test "destroys an account" do
    assert_difference("CreditAccount.count", -1) do
      delete credit_account_url(@account)
    end
  end
end
