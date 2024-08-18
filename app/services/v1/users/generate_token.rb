# frozen_string_literal: true
module V1
  module Users
    class GenerateToken < ServiceBase
      def initialize(user:)
        @user = user
      end

      def call
        generate_token
      end

      private

      attr_reader :user

      def private_key
        OpenSSL::PKey::RSA.new(ENV['USER_JWT_PRIVATE_KEY'].gsub('\\n', "\n"))
      end

      def generate_token
        token = JWT.encode(user.decorate.jwt_payload, private_key, 'RS256') 
        Success(token)
      end
    end
  end
end
