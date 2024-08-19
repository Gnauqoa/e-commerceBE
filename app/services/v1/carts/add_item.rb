module V1
  module Carts
    class AddItem < ServiceBase
      def initialize(product_id:, current_user:, quantity:)
        @product_id = product_id
        @current_user = current_user
        @quantity = quantity
      end

      def call
        add_item
      end

      private


      attr_reader :product_id, :current_user, :quantity

      def add_item
        product = Product.find_by(id: product_id)
        return Failure[:product_not_found, 'Product not found'] if product.nil?
        return Failure[:insufficient_stock, 'Insufficient stock'] if product.stock < quantity.to_i

        cart_item = CartItem.find_or_initialize_by(
          user_id: current_user.id,
          product_id:
        )

        cart_item.quantity = cart_item.quantity.to_i + quantity.to_i

        if cart_item.save
          Success(cart_item)
        else
          Failure[:create_failed, cart_item.errors.full_messages]
        end
      end
    end
  end
end