require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:name) }
  it { should have_many(:transactions).class_name('Transaction').dependent(:destroy) }
end
