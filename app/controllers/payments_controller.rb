class PaymentsController < ApplicationController
  before_action :set_account

  def create
    @payment = @account.payments.build(payment_params)
    if @payment.save
      redirect_to @account, notice: "Payment scheduled."
    else
      redirect_to @account, alert: @payment.errors.full_messages.to_sentence
    end
  end

  def mark_paid
    @account.payments.find(params[:id]).mark_paid!
    redirect_to @account, notice: "Payment recorded — nice, that builds history."
  end

  def destroy
    @account.payments.find(params[:id]).destroy
    redirect_to @account, notice: "Payment removed.", status: :see_other
  end

  private

  def set_account
    @account = current_user.credit_accounts.find(params[:credit_account_id])
  end

  def payment_params
    params.require(:payment).permit(:amount_cents, :due_on)
  end
end
