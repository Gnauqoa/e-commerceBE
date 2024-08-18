module V1
  module Users
    class Products < PublicBase
      resources :products do
        desc 'Get products',
            summary: 'Get products'
        params do
          optional :page, type: Integer, desc: 'Page # from 1'
          optional :per_page, type: Integer, desc: 'Number of item per page'
        end
        get do
          paginated_response(Product.all)
        end

        desc 'Get product',
            summary: 'Get product'
        params do
          requires :id, type: Integer, desc: 'Product ID'
        end
        get ':id' do
          product = Product.find(params[:id])

          if product.present?
            format_response(product)
          else
            error!(failure_response('Product not found'), 404)
          end
        end
      end
    end
  end
end