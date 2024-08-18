# frozen_string_literal: true

module Platforms
  class CreateOrUpdate < ServiceBase
    def initialize(params:)
      @params = params.with_indifferent_access
    end

    def call
      find_or_initialize
      create_or_update
    end

    private

    attr_reader :platform, :params

    def find_or_initialize
      @platform = params[:id].present? ? Platform.find_by(id: params[:id]) : Platform.new(params)
    end

    def generate_authentication_data
      return if platform.persisted?

      platform.client_id = SecureRandom.uuid.gsub('-', '')
      key_pair = OpenSSL::PKey::RSA.new(4096)
      platform.private_key = key_pair.to_s
      platform.public_key = key_pair.public_key.to_s
    end

    def create_or_update
      return Failure[:platform_not_found] unless platform

      generate_authentication_data
      platform.assign_attributes(params.except(:client_id, :public_key, :private_key))
      if platform.save
        Success(platform)
      else
        Failure[:create_failed, platform.errors.full_messages]
      end
    end
  end
end
