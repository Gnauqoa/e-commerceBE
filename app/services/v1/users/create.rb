# frozen_string_literal: true
module V1
  module Users
    class Create < ServiceBase
      def initialize(params:)
        @params = params
      end

      def call
        create_user
      end

      private

      attr_reader :params

      def create_user
        user = User.new(params)
        if user.save
          Success(user)
        else
          Failure[:create_failed, user.errors.full_messages]
        end
      end
    end
  end
end
