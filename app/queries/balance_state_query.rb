require 'dry/monads'
require 'dry/monads/do'

class BalanceStateQuery
  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:call)

  def call(params)
    symbolized_params = params.to_h.symbolize_keys

    valid_params = yield validate(symbolized_params)
    result = yield find(valid_params)

    Success(result)
  end

  private

  def validate(params)
    res = QueryTransactionValidate.new.call(params)

    res.success? ? Success(res.to_h) : Failure(res.errors.to_h)
  end

  def find(params)
    sum_start = Transaction.transactions_sum_for_period(params[:user_id], params[:start])
    sum_finish = Transaction.transactions_sum_for_period(params[:user_id], params[:finish])

    Success({ sum_start: sum_start, sum_finish: sum_finish })
  end
end
