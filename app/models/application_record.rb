class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { writing: :balance, reading: :balance_replica }
end
