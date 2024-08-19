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
            cart_items = current_user.cart_items
            return error!(failure_response('Cart is empty'), 404) if cart_items.empty? 

            products = Product.where(id: cart_items.map { |cart_item| cart_item[:product_id] })
            product_stocks = products.pluck(:id, :stock).to_h
            cart_items.each do |cart_item|
              return error!(failure_response('Insufficient stock for product'), 404) if product_stocks[cart_item[:product_id]] < cart_item[:quantity]
            end
            total_amount = products.sum(&:price)

            order = Order.new(
              user_id: current_user.id,
              status: :completed,
              total_amount:,
            )
           
            if (params[:discount_id].present?)
              discount = Discount.active.find(params[:discount_id])
              user_discount = ::V1::UserDiscounts::Create.call(params: { 
                total_amount:, user_id: current_user.id, discount_id: discount.id 
              }).success
              if discount.rule == :direct
                order.discount_amount = discount.percentage * total_amount / 100
                order.total_final = total_amount - order.discount_amount
                order.user_discount_id = user_discount.id
                user_discount.update(status: :used, order_id: order.id)
              else 
                order.discount_id = discount.id
                order.total_final = total_amount
              end
            elsif (params[:user_discount_id].present?)
              user_discount = current_user.user_discounts.avaliable.find(params[:user_discount_id])
              if user_discount.discount.total_require <= total_amount
                order.discount_amount = user_discount.discount.percentage * total_amount / 100
                order.total_final = total_amount - order.discount_amount
                order.user_discount_id = user_discount.id
                user_discount.update(status: :used, order_id: order.id)
              else
                return error!(failure_response('Not enough total require'), 404)
              end
            end

            
            if order.save
              cart_items.each do |cart_item|
                product = products.find { |product| product.id == cart_item[:product_id] }
                if product.nil?
                  next
                end
                product.stock -= cart_item[:quantity]
                product.save
                order.order_items.create(
                  quantity: cart_item[:quantity],
                  price: product.price,
                  product_metadata: product.to_json
                )
              end

              current_user.cart_items.destroy_all
              status 201
              format_response(order, serializer: UserOrderSerializer)
            else
              error!(failure_response(*order.failure), 422)
            end
          end

          desc 'Get orders',
              summary: 'Get orders'
          params do
            optional :page, type: Integer, desc: 'Page # from 1'
            optional :per_page, type: Integer, desc: 'Number of item per page'
          end
          get do
            paginated_response(current_user.orders.order(created_at: :desc), serializer: UserOrderSerializer)
          end

          desc 'Get order',
              summary: 'Get order'
          params do
            requires :id, type: Integer, desc: 'Order ID'
          end
          get ':id' do
            order = Order.find_by(id: params[:id], user_id: current_user.id)

            if order.present?
              format_response(order, serializer: UserOrderSerializer)
            else
              error!(failure_response('Order not found'), 404)
            end
          end
        end
      end
    end
  end
end