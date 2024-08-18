# frozen_string_literal: true

class ServiceBase
  include Dry::Monads[:result, :do]

  DEFAULT_PAGE_INDEX = 1
  DEFAULT_ITEM_PER_PAGE = 30

  def self.call(**args)
    service = new(**args)
    service.call
  end

  protected

  def log_error(err, args = {})
    info = { class_name: self.class.to_s }
    info.merge!(args) if args.present?
    if err.is_a? StandardError
      logger.error("Exception in #{self.class}: #{err.message}")
      logger.error("Request: #{info}")
      logger.error("Trace: #{err.backtrace.join("\n")}")
    else
      logger.error("Exception in #{self.class}: #{err}")
    end
  end

  def logger
    Rails.logger
  end
end
