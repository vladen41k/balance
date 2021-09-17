class QueryTransactionValidate < Dry::Validation::Contract
  params do
    required(:user_id).value(:integer)
    required(:start).value(:date_time)
    required(:finish).value(:date_time)
  end

  rule(:user_id) do
    next if User.where(id: value).exists?

    key.failure('user not found')
  end
end
