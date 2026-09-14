module Api
  module V1
    class CreditAccountsController < BaseController
      def index
        accounts = current_user.credit_accounts.includes(:payments)
        render json: accounts.map { |a| serialize(a) }
      end

      def show
        account = current_user.credit_accounts.find(params[:id])
        render json: serialize(account, with_payments: true)
      rescue ActiveRecord::RecordNotFound
        render json: { error: "not found" }, status: :not_found
      end

      private

      def serialize(account, with_payments: false)
        data = {
          id: account.id,
          name: account.name,
          status: account.status,
          credit_limit_cents: account.credit_limit_cents,
          balance_cents: account.balance_cents,
          utilization: account.utilization.round(4),
          opened_on: account.opened_on
        }
        if with_payments
          data[:payments] = account.payments.map do |p|
            p.slice(:id, :amount_cents, :due_on, :paid_on, :status)
          end
        end
        data
      end
    end
  end
end
