module V1
  module Users
    class Discounts < PublicBase
      resources :discounts do
        desc 'Update discount',
            summary: 'Update discount'
        params do
          optional :name, type: String, desc: 'Name'
          optional :percentage, type: BigDecimal, desc: 'Percentage'
        end
        put ':id' do
          discount = Discount.find(params[:id])

          if discount.present?
            if discount.update(declared(params))
              format_response(discount)
            else
              error!(failure_response(discount.errors.full_messages), 422)
            end
          else
            error!(failure_response('Discount not found'), 404)
          end
        end
        desc 'Get discounts',
            summary: 'Get discounts'
        params do
          optional :page, type: Integer, desc: 'Page # from 1'
          optional :per_page, type: Integer, desc: 'Number of item per page'
          optional :status, type: String, desc: 'Status', values: ['active', 'inactive', 'all'], default: 'active'
        end
        get do
          discounts = Discount.where(status: params[:status]) if params[:status] != 'all'
          current_time = Time.now
          discounts = discounts.where('start_date <= ? AND end_date >= ?', current_time, current_time)
          paginated_response(discounts)
        end

        desc 'Check available discounts',
            summary: 'Check available discounts'
        params do
          optional :page, type: Integer, desc: 'Page # from 1'
          optional :per_page, type: Integer, desc: 'Number of item per page'
          optional :total_amount, type: BigDecimal, desc: 'Total amount'
        end
        get 'available' do
          discounts = Discount.where(status: :active)
          current_time = Time.now
          discounts = discounts.where('start_date <= ? AND end_date >= ?', current_time, current_time)
          
          if params[:total_amount].present?
            discounts = discounts.where('total_require <= ?', params[:total_amount])
          end
          
          paginated_response(discounts)
        end

        desc 'Get discount',
            summary: 'Get discount'
        params do
          requires :id, type: Integer, desc: 'Discount ID'
        end

        get ':id' do
          discount = Discount.find(params[:id])

          if discount.present?
            format_response(discount)
          else
            error!(failure_response('Discount not found'), 404)
          end
        end
      end
    end
  end
end