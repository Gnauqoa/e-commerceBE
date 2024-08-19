module V1
  module UserDiscounts
    class Create < ServiceBase
      def initialize(params:)
        @params = params
      end

      def call
        create_user_discount
      end

      private

      attr_reader :params

      def create_user_discount
        discount = Discount.active.find(params[:discount_id])
        return Failure[:discount_not_found, 'Discount not found'] if discount.nil?
        return Failure[:stock_empty, 'Stock empty'] if discount.stock <= 0
        return Failure[:total_require_not_enough, 'Not enough total require'] if params[:total_amount] && discount.total_require > params[:total_amount]
        discount.stock -= 1
        discount.save
        user_discount = UserDiscount.new(params)
       
        if user_discount.save
          Success(user_discount)
        else
          Failure[:create_failed, user_discount.errors.full_messages]
        end
      end
    end
  end
end