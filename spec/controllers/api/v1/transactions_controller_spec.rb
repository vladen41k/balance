require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  let!(:user) { create :user }
  let!(:transactions) { create_list :transaction, 5, user: user }

  describe 'GET #account_statement' do
    context 'when valid params' do
      it 'show new transactions' do
        get :account_statement,
            params: { start: Time.current - 5.minutes, finish: Time.current + 5.seconds, user_id: user.id }

        expect(response.successful?).to eq true
        expect(JSON.parse(response.body)['transactions'].size).to eq transactions.size
      end

      context 'when present old param' do
        let!(:old_transaction) { create :transaction, user: user, created_at: Time.current - 3.weeks }

        it 'show all transactions' do
          get :account_statement,
              params: { start: Time.current - 1.month, finish: Time.current + 5.seconds, user_id: user.id }

          expect(response.successful?).to eq true
          expect(JSON.parse(response.body)['transactions'].size).to eq Transaction.all.size
        end

        it 'show new transactions' do
          get :account_statement,
              params: { start: Time.current - 5.minutes, finish: Time.current + 5.seconds, user_id: user.id }

          expect(response.successful?).to eq true
          expect(JSON.parse(response.body)['transactions'].size).to eq transactions.size
          expect(Transaction.all.size).to_not eq transactions.size
        end
      end
    end

    context 'when invalid params' do
      it 'return errors' do
        get :account_statement, params: { start: 858, finish: Time.current + 5.seconds, user_id: user.id + 5 }

        response_body = JSON.parse(response.body)
        expect(response.successful?).to eq false
        expect(response_body['errors']['user_id']).to eq ['user not found']
        expect(response_body['errors']['start']).to eq ['must be a date time']
      end
    end
  end

  describe 'GET #balance_state' do
    context 'when valid params' do
      let(:sum_new_transactions) do
        Money.from_cents(transactions.inject(0) do |a, b|
                           a + b.amount
                         end, Transaction::CURRENCY_RUB).format
      end

      it 'show balance' do
        get :balance_state,
            params: { start: Time.current - 5.minutes, finish: Time.current + 5.seconds, user_id: user.id }

        expect(response.successful?).to eq true
        expect(JSON.parse(response.body)['sum_start']).to eq '0.00 ₽'
        expect(JSON.parse(response.body)['sum_finish']).to eq sum_new_transactions
      end

      context 'when present old transaction' do
        let!(:old_transaction) { create :transaction, user: user, created_at: Time.current - 3.weeks }
        let(:sum_all_transactions) do
          Money.from_cents(Transaction.pluck(:amount).inject(0) do |a, b|
                             a + b
                           end, Transaction::CURRENCY_RUB).format
        end
        let(:sum_old_transaction) { Money.from_cents(old_transaction.amount, Transaction::CURRENCY_RUB).format }

        it 'show balance with old transaction' do
          get :balance_state,
              params: { start: Time.current - 5.minutes, finish: Time.current + 5.seconds, user_id: user.id }

          expect(response.successful?).to eq true
          expect(JSON.parse(response.body)['sum_start']).to eq sum_old_transaction
          expect(JSON.parse(response.body)['sum_finish']).to eq sum_all_transactions
        end
      end
    end

    context 'when invalid params' do
      it 'return errors' do
        get :balance_state, params: { start: 858, finish: Time.current + 5.seconds, user_id: user.id + 5 }

        response_body = JSON.parse(response.body)
        expect(response.successful?).to eq false
        expect(response_body['errors']['user_id']).to eq ['user not found']
        expect(response_body['errors']['start']).to eq ['must be a date time']
      end
    end
  end

  describe 'POST #create' do
    context 'when valid params' do
      let(:sum_transactions_before_create) do
        Money.from_cents(Transaction.pluck(:amount).inject(0) do |a, b|
                           a + b
                         end, Transaction::CURRENCY_RUB).format
      end

      it 'create new Transaction' do
        params = { user_id: user.id, amount: 50_000 }

        expect { post :create, params: params }.to change(Transaction, :count).by(1)
        expect(response.successful?).to eq true
        expect(JSON.parse(response.body)).to_not eq sum_transactions_before_create
      end
    end

    context 'when invalid params' do
      context 'when user id absent' do
        it 'Transaction not created' do
          params = { user_id: user.id + 5, amount: 50_000 }

          expect { post :create, params: params }.to change(Transaction, :count).by(0)
          expect(response.successful?).to eq false
          expect(JSON.parse(response.body)['errors']['user']).to eq ['must exist']
        end
      end

      context 'when amount equal zero' do
        it 'Transaction not created' do
          params = { user_id: user.id, amount: 0 }

          expect { post :create, params: params }.to change(Transaction, :count).by(0)
          expect(response.successful?).to eq false
          expect(JSON.parse(response.body)['errors']['amount']).to eq ['must be other than 0']
        end
      end

      context 'when amount is absent' do
        it 'Transaction not created' do
          params = { user_id: user.id }

          expect { post :create, params: params }.to change(Transaction, :count).by(0)
          expect(response.successful?).to eq false
          expect(JSON.parse(response.body)['errors']['amount']).to eq ["can't be blank", 'is not a number']
        end
      end
    end
  end
end
