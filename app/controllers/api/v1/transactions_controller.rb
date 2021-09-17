module Api
  module V1
    class TransactionsController < ApplicationController
      def account_statement
        query = AccountStatementQuery.new.call(permit_params)

        if query.success?
          render json: AccountStatementPresenter.new(query.success).call, status: :ok
        else
          render json: { errors: query.failure.to_h }, status: :bad_request
        end
      end

      def balance_state
        query = BalanceStateQuery.new.call(permit_params)

        if query.success?
          render json: BalanceStatePresenter.new(query.success).call, status: :ok
        else
          render json: { errors: query.failure.to_h }, status: :bad_request
        end
      end

      def create
        transaction = Transaction.new(permit_params)

        if transaction.save
          render json: TransactionPresenter.new(transaction).call, status: :created
        else
          render json: { errors: transaction.errors.messages }, status: :bad_request
        end
      end

      private

      def permit_params
        params.permit(:amount, :start, :finish, :user_id)
      end
    end
  end
end
