module Api
  module V1
    class UsersController < ApplicationController
      def index
        render json: User.all.to_json, status: :ok
      end

      def create
        user = User.new(user_params)

        if user.save
          render json: user.to_json, status: :created
        else
          render json: { errors: user.errors.messages }, status: :bad_request
        end
      end

      private

      def user_params
        params.permit(:name)
      end
    end
  end
end
