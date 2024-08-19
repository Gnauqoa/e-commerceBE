module V1
  module Carts
    class RemoveItem < ServiceBase
      def initialize(product_id:, current_user:, quantity:)
        @product_id = product_id
        @current_user = current_user
        @quantity = quantity
      end

      def call
        remove_item
      end

      private

      attr_reader :product_id, :current_user, :quantity

      def remove_item
        cart_item = CartItem.find_by(
          user_id: current_user.id,
          product_id: product_id
        )

        if cart_item.present?
          cart_item.quantity = cart_item.quantity.to_i - quantity.to_i

          if cart_item.quantity <= 0
            cart_item.destroy
          else
            cart_item.save
          end

          Success(cart_item)
        else
          Failure[:product_not_found, 'Product not found']
        end
      end
    end
  end
end