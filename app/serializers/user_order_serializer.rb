class UserOrderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :total_amount, :discount_amount, :total_final, :status, :discount, :user_discount, :created_at, :updated_at
  belongs_to :user_discount, serializer: OrderUserDiscountSerializer
  has_many :order_items
end