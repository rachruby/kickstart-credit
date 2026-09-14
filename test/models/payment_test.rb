require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  test "mark_paid! before due date records on-time payment" do
    payment = payments(:upcoming)
    payment.mark_paid!(on: payment.due_on - 1.day)
    assert payment.paid?
  end

  test "mark_paid! after due date records late payment" do
    payment = payments(:upcoming)
    payment.mark_paid!(on: payment.due_on + 3.days)
    assert payment.late?
  end

  test "user on_time_rate counts only settled payments" do
    # Fixtures: one paid, one late, one still scheduled -> 1/2
    assert_in_delta 0.5, users(:demo).on_time_rate, 0.001
  end
end
