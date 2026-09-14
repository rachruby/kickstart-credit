require "test_helper"

class ApiCreditAccountsTest < ActionDispatch::IntegrationTest
  test "index returns serialized accounts with utilization" do
    get api_v1_credit_accounts_url, as: :json
    assert_response :success

    body = JSON.parse(response.body)
    account = body.find { |a| a["name"] == "KickStart Credit Builder" }
    assert_equal 0.25, account["utilization"]
  end

  test "show returns payments and 404s cleanly" do
    get api_v1_credit_account_url(credit_accounts(:builder)), as: :json
    assert_response :success
    assert JSON.parse(response.body)["payments"].any?

    get api_v1_credit_account_url(id: 999_999), as: :json
    assert_response :not_found
  end
end
