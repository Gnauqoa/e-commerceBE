# frozen_string_literal: true

module V1
  module Users
    class Users < PublicBase
      resources :users do
        # after do
        #   user = User.find_by_email(params[:email])
        #   user ||= User.find_by(username: params[:email])

        #   log_ip(user.id, client_ip)
        # end

        desc 'Register User',
            summary: 'Register'
        params do
          optional :username, type: String, regexp: /\A[a-z0-9_]{4,16}\z/, desc: 'Username'
          requires :email, type: String, regexp: URI::MailTo::EMAIL_REGEXP,
                          desc: 'The unique login email'
          requires :password, type: String, desc: 'The login password'
          requires :first_name, type: String, desc: 'First name'
          requires :last_name, type: String, desc: 'Last name'
          requires :birth, type: Date, desc: 'Birth date'
        end
        post do
          return error!("Email already exists", 422) if User.find_by_email(params[:email])
          user_params = declared(params, include_missing: false)

          result = Create.new(
            params: user_params.except(:recaptcha_token),

          ).call

          if result.success?
            status 201
            generate_token_result = GenerateToken.new(user: result.success).call
            token = generate_token_result.success
            format_response({ access_token: token })
          else
            error!(failure_response(*result.failure), 422)
          end
        end
      
        desc 'Sign In',
            summary: 'Sign In'
        params do
          requires :account, type: String,
                          desc: 'Email or username'
          requires :password, type: String, desc: 'The login password'
        end

        post :sign_in do
          @result = SignIn.new(
            email: params[:account],
            password: params[:password],
            request: env['warden'].request
          ).call

          if @result.success?
            status 200
            format_response({ access_token: @result.success })
          else
            error!(failure_response(*@result.failure), 422)
          end
        end
      end
    end
  end
end
