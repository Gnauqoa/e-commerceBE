# frozen_string_literal: true

module BaseHelper
  extend ActiveSupport::Concern

  included do
    version name.split('::')[0].downcase.to_s, using: :path, vendor: 'api', strict: false
    include ResponseHelper

    helpers do
      include Pundit::Authorization

      def log_ip(user_id, client_ip)
        action = request.env['REQUEST_PATH'].split('/').last
        RequestLog.create!(ip_address: client_ip, action: action, user_id:)
      end
    end

    rescue_from Grape::Exceptions::ValidationErrors do |error|
      error!(failure_response(error[:message]), 422)
    end

    rescue_from Grape::Exceptions::Base do |error|
      Rails.logger.error("Exception in #{self.class}: #{error.message}")
      Rails.logger.error("Trace: #{error.backtrace.join("\n")}")
      error!(failure_response(error[:message]), 422)
    end

    rescue_from ActiveRecord::RecordNotFound do |error|
      error!(failure_response("#{error.model} is not found"), 404)
    end

    rescue_from Pundit::NotAuthorizedError do
      error!(failure_response('Unauthorized'), 403)
    end
  end
end
