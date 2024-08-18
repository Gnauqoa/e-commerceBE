# frozen_string_literal: true
module V1
  module Users
    class Update < ServiceBase
      def initialize(user:, params:)
        @user = user
        @params = params.with_indifferent_access
      end

      def call
        yield validate_password_if_needed
        update_user
      end

      private

      attr_reader :user, :params

      def validate_password_if_needed
        return Success() unless params[:password]
        return Success() if user.valid_password?(params[:current_password])

        Failure[:update_failed, :invalid_password]
      end

      def update_user
        user.assign_attributes(params.slice(*%i[email first_name last_name password]))

        if user.save
          Success(user)
        else
          Failure[:update_failed, user.errors.full_messages]
        end
      end
    end
  end
end