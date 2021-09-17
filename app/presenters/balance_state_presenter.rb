class BalanceStatePresenter
  def initialize(params)
    @sum_start = params[:sum_start]
    @sum_finish = params[:sum_finish]
  end

  def call
    { sum_start: Money.from_cents(@sum_start, Transaction::CURRENCY_RUB).format,
      sum_finish: Money.from_cents(@sum_finish, Transaction::CURRENCY_RUB).format }
  end
end
