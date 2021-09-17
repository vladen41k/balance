class Transaction < ApplicationRecord
  CURRENCY_RUB = 'RUB'.freeze

  validates :amount, presence: true, numericality: { other_than: 0 }

  belongs_to :user

  scope :transactions_sum_for_period, lambda { |user_id, date|
    where(user_id: user_id).where('created_at <= ?', date).sum(:amount)
  }
end
