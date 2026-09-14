class CreditAccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update destroy]

  def index
    @accounts = current_user.credit_accounts.order(:created_at)
  end

  def show
    @payments    = @account.payments
    @new_payment = @account.payments.build(due_on: Date.current.next_month)
  end

  def new
    @account = current_user.credit_accounts.build(opened_on: Date.current)
  end

  def create
    @account = current_user.credit_accounts.build(account_params)
    if @account.save
      redirect_to @account, notice: "Credit account opened."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @account.update(account_params)
      redirect_to @account, notice: "Account updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy
    redirect_to credit_accounts_path, notice: "Account removed.", status: :see_other
  end

  private

  def set_account
    @account = current_user.credit_accounts.find(params[:id])
  end

  def account_params
    params.require(:credit_account)
          .permit(:name, :credit_limit_cents, :balance_cents, :opened_on, :status)
  end
end
