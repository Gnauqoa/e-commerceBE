# frozen_string_literal: true
module V1
  module Users
    class SignIn < ServiceBase
      def initialize(email:, password:, request:)
        @email = email
        @password = password
        @request = request
      end

      def call
        yield find_user
        yield valid_password?
        token = yield generate_token
        user.update_tracked_fields(request)
        user.save
        Success(token)
      end

      private

      attr_reader :user, :email, :password, :request

      def find_user
        return Failure[:email_or_wallet_address_is_required, 'Email or username is required'] unless email

        @user = User.find_by(email:)

        @user ||= User.find_by(username: email)

        return Failure[:invalid_username_or_password, 'Invalid email, username or password'] unless user

        Success(user)
      end

      def valid_password?
        if user.valid_password?(password)
          Success(user)
        else
          Failure[:invalid_username_or_password, 'Invalid email, username or password']
        end
      end

      def generate_token
        GenerateToken.new(user:).call
      end
    end
  end
end