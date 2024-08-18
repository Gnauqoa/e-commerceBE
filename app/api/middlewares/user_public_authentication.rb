# frozen_string_literal: true

module Middlewares
  class UserPublicAuthentication
    CLIENT_ID_KEYS = %w[CLIENT_ID HTTP_CLIENT_ID X-HTTP_CLIENT_ID X_HTTP_CLIENT_ID].freeze
    HOST_KEYS = %w[HOST HTTP_HOST X-HTTP_HOST X_HTTP_HOST].freeze

    def initialize(app)
      @app = app
    end

    def call(env)
      auth = JwtRequest.new(env)
      
      env['REMOTE_USER'] = auth.user_data if auth.valid? && auth.bearer? && auth.user_data
      @app.call(env)
    rescue JWT::DecodeError => e
      unauthorized(e.message)
    end

    private

    def unauthorized(errors = [])
      [401,
       {
         Rack::CONTENT_TYPE => 'application/json'
       },
       [
         {
           error: {
             message: :unauthorized,
             errors: errors.is_a?(Array) ? errors : [errors]
           }
         }.to_json
       ]]
    end

    class JwtRequest < Rack::Auth::AbstractRequest
      def bearer?
        scheme == 'bearer' && credentials.present? && credentials.length == 2
      end

      def public_key
        OpenSSL::PKey::RSA.new(ENV['USER_JWT_PUBLIC_KEY'].gsub('\\n', "\n"))
      end

      def credentials
        @credentials ||= JWT.decode(params, public_key, true, algorithm: 'RS256')
      end

      def user_data
        credentials.first['user']
      end

      def client_ip
        @env['action_dispatch.remote_ip'].to_s
      end
    end
  end
end
