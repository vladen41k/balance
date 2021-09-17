require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { should validate_presence_of(:amount) }
  it { should validate_numericality_of(:amount).is_other_than(0) }
  it { should belong_to(:user) }
end
