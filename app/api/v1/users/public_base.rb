# frozen_string_literal: true

module V1
  module Users
    class PublicBase < Grape::API
      def self.inherited(subclass)
        super

        subclass.instance_eval do
          include BaseHelper
          use Middlewares::UserPublicAuthentication

          helpers do
            def client_id_key
              Middlewares::UserPublicAuthentication::CLIENT_ID_KEYS.detect { |key| env.key?(key) }
            end

            def platform
              @platform ||= Platform.find_by!('client_id = ? OR ? = ANY(hosts)', client_id, host)
            end

            def client_id
              env[client_id_key]
            end

            def host_key
              Middlewares::UserPublicAuthentication::HOST_KEYS.detect { |key| @env.key?(key) }
            end

            def client_ip
              env['action_dispatch.remote_ip'].to_s
            end

            def host
              @env[host_key]
            end

            def remote_user
              env['REMOTE_USER'] if env['REMOTE_USER'].present?
            end

            def user_id
              return nil unless remote_user

              remote_user['id']
            end

            def current_user
              return @current_user if defined? @current_user
              return nil if user_id.nil?

              @current_user = User.find(user_id)
            end
          end
        end
      end
    end
  end
end