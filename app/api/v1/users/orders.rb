module V1
  module Users
    class Orders < Base
      resources :users do
        namespace "order" do
          desc 'Create order',
              summary: 'Create order'
          params do
            optional :discount_id, type: Integer, desc: 'Discount ID'
            optional :user_discount_id , type: Integer, desc: 'User Discount ID'
          end
          post do
            order = Order.new(
              user_id: current_user.id,
              status: :completed,
            )

            if order.save
              current_user.cart_items.each do |cart_item|
                product = Product.find(cart_item[:product_id])

                order_item = OrderItem.new(
                  order_id: order.id,
                  product_id: product.id,
                  quantity: cart_item[:quantity],
                  price: product.price
                )

                order_item.save
              end

              status 201
              format_response(order)
            else
              error!(failure_response(*order.errors.full_messages), 422)
            end
          end

          desc 'Get orders',
              summary: 'Get orders'
          params do
            optional :page, type: Integer, desc: 'Page # from 1'
            optional :per_page, type: Integer, desc: 'Number of item per page'
          end
          get do
            paginated_response(current_user.orders)
          end

          desc 'Get order',
              summary: 'Get order'
          params do
            requires :id, type: Integer, desc: 'Order ID'
          end
          get ':id' do
            order = Order.find_by(id: params[:id], user_id: current_user.id)

            if order.present?
              format_response(order)
            else
              error!(failure_response('Order not found'), 404)
            end
          end
        end
      end
    end
  end
end