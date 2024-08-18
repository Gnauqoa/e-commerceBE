# frozen_string_literal: true

module ResponseHelper
  extend ActiveSupport::Concern

  included do
    helpers do
      def format_response(record, options = {})
        return unless record

        serializer = options[:serializer] || serializer_for(record)
        {
          data: serializer ? serializer.new(record, scope: options[:scope]).as_json : record.as_json
        }
      end

      def paginated_collection
        offset = (@page - 1) * @per_page
        if @collection.is_a?(ActiveRecord::Relation)
          @collection.offset(offset).limit(@per_page)
        else
          @collection[offset..(offset + @per_page)]
        end
      end

      def total_pages
        (@collection_count / @per_page.to_f).ceil
      end

      def paginated_response(collection, options = {})
        @collection = collection
        @page = params[:page] || 1
        @per_page = params[:per_page] || 50
        if @collection.is_a?(Hash)
          collection = collection[:items]
          @collection = @collection[:items]
          @collection_count = collection.try(:count)
          data = paginated_collection.to_json
          {
            data: {
              items: JSON.parse(data),
              total_items: @collection_count,
              total_pages:,
              current_page: @page,
              per_page: @per_page
            }
          }
        else
          @collection_count = collection.try(:count)
          serializer = options[:serializer] || serializer_for(collection)
          items = ActiveModelSerializers::SerializableResource.new(
            paginated_collection,
            each_serializer: serializer,
            include: options[:include],
            scope: options[:scope]
          )
          response = {
            data: {
              items:,
              total_items: @collection_count,
              total_pages:,
              current_page: @page,
              per_page: @per_page
            }
          }
          response[:data].merge!(extra: options[:extra]) if options[:extra]
          response
        end
      end

      def failure_response(message, errors = [])
        {
          error: {
            message:,
            errors: errors.is_a?(Array) ? errors : [errors].compact
          }
        }
      end

      def aas_failure_response(error)
        {
          status: 0,
          error:
        }
      end

      def aas_success_response(object)
        { status: 1 }.merge(object)
      end

      def we_success_response(object)
        object
      end

      def pragmatic_success_response(object)
        object
      end

      def serializer_for(record)
        case record
        when ActiveRecord::Relation
          "#{record.klass}Serializer".safe_constantize
        when ApplicationRecord
          "#{record.class}Serializer".safe_constantize
        end
      end
    end
  end
end
