# frozen_string_literal: true
module V1
  module Users
    class Base < Grape::API
      def self.inherited(subclass)
        super

        subclass.instance_eval do
          include BaseHelper
          use Middlewares::UserJwtAuthentication

          helpers do
            def remote_user
              env['REMOTE_USER']
            end

            def user_id
              remote_user['id']
            end

            def current_user
              return @current_user if defined? @current_user

              @current_user = User.find(user_id)
            end

            def client_ip
              env['action_dispatch.remote_ip'].to_s
            end
          end
        end
      end
    end
  end
end