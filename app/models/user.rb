class User < ApplicationRecord
  validates :name, presence: true

  has_many :transactions, dependent: :destroy
end
