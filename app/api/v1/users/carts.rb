module V1
  module Users
    class Carts < PublicBase
      resources :users do
        namespace "cart" do
          desc 'Add product to cart',
              summary: 'Add product to cart'
          params do
            requires :product_id, type: Integer, desc: 'Product ID'
            requires :quantity, type: Integer, desc: 'Quantity'
          end
          post do
            cart_item = ::V1::Carts::AddItem.call(product_id: params[:product_id], current_user: current_user, quantity: params[:quantity])
            if cart_item.success?
              status 201
              format_response(cart_item.success)
            else
              error!(failure_response(*cart_item.failure), 422)
            end
          end

          desc 'Remove product from cart',
              summary: 'Remove product from cart'
          params do
            requires :product_id, type: Integer, desc: 'Product ID'
            requires :quantity, type: Integer, desc: 'Quantity'
          end
          delete do
            cart_item = ::V1::Carts::RemoveItem.call(product_id: params[:product_id], current_user: current_user, quantity: params[:quantity])
            if cart_item.success?
              status 204
            else
              error!(failure_response(*cart_item.failure), 422)
            end
          end

          desc 'Get cart',
              summary: 'Get cart'
          params do
            optional :page, type: Integer, desc: 'Page # from 1'
            optional :per_page, type: Integer, desc: 'Number of item per page'  
          end
          get do
            if (!current_user)
              error!(failure_response('Unauthorized'), 401)
            end
            cart_items = CartItem.where(user_id: current_user.id).order(created_at: :desc)

            paginated_response(cart_items)
          end
        end
      end
    end
  end
end