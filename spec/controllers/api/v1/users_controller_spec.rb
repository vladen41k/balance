require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:users) { create_list :user, 3 }

  describe 'GET #index' do
    it 'show all users' do
      get :index

      expect(response.successful?).to eq true
      expect(JSON.parse(response.body).size).to eq users.size
    end
  end

  describe 'POST #create' do
    context 'when valid params' do
      it 'create new User' do
        params = { name: Faker::Name.name }

        expect { post :create, params: params }.to change(User, :count).by(1)
        expect(response.successful?).to eq true
      end
    end

    context 'when invalid params' do
      context 'when name id absent' do
        it 'User not created' do
          expect { post :create, params: {} }.to change(User, :count).by(0)
          expect(response.successful?).to eq false
          expect(JSON.parse(response.body)['errors']['name']).to eq ['can\'t be blank']
        end
      end
    end
  end
end
