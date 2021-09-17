class TransactionPresenter
  def initialize(params)
    @transaction = params.attributes
    @transaction['amount'] = Money.from_cents(@transaction['amount'],
                                              Transaction::CURRENCY_RUB).format

    @sum = Transaction.transactions_sum_for_period(@transaction['user_id'], @transaction['created_at'])
    @sum = Money.from_cents(@sum, Transaction::CURRENCY_RUB).format
  end

  def call
    { total_sum: @sum, transaction: @transaction }
  end
end
