class OrderUserDiscountSerializer < ActiveModel::Serializer
  attributes :id, :status, :discount, :created_at, :updated_at
end