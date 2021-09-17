class AccountStatementPresenter
  PAYMENT = 'payment'.freeze
  WITHDRAWAL = 'withdrawal'.freeze

  def initialize(params)
    @transactions = params[:transactions]
    @sum = Money.from_cents(params[:sum], Transaction::CURRENCY_RUB).format
  end

  def call
    { total_sum: @sum, transactions: decorate_transactions }
  end

  private

  def decorate_transactions
    @transactions.map do |t|
      { id: t.id, amount: Money.from_cents(t.amount, Transaction::CURRENCY_RUB).format,
        status: (t.amount.positive? ? PAYMENT : WITHDRAWAL), created_at: t.created_at }
    end
  end
end
