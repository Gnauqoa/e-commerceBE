module V1
  module Users
    class Cart < PublicBase
      resources :users do
        namespace "cart" do
          desc 'Add product to cart',
              summary: 'Add product to cart'
          params do
            requires :product_id, type: Integer, desc: 'Product ID'
            requires :quantity, type: Integer, desc: 'Quantity'
          end
          post do
            cart_item = CartItem.find_or_initialize_by(
              user_id: current_user.id,
              product_id: params[:product_id]
            )

            cart_item.quantity = cart_item.quantity.to_i + params[:quantity].to_i

            if cart_item.save
              status 201
              format_response(cart_item)
            else
              error!(failure_response(*cart_item.errors.full_messages), 422)
            end
          end

          desc 'Remove product from cart',
              summary: 'Remove product from cart'
          params do
            requires :product_id, type: Integer, desc: 'Product ID'
            requires :quantity, type: Integer, desc: 'Quantity'
          end
          delete do
            cart_item = CartItem.find_by(
              user_id: current_user.id,
              product_id: params[:product_id]
            )

            if cart_item.present?
              cart_item.quantity = cart_item.quantity.to_i - params[:quantity].to_i

              if cart_item.quantity <= 0
                cart_item.destroy
              else
                cart_item.save
              end

              status 204
            else
              error!(failure_response('Product not found'), 404)
            end
          end

          desc 'Get cart',
              summary: 'Get cart'
          get do
            if (!current_user)
              error!(failure_response('Unauthorized'), 401)
            end
            cart_items = CartItem.where(user_id: current_user.id)

            paginated_response(cart_items)
          end
        end
      end
    end
  end
end