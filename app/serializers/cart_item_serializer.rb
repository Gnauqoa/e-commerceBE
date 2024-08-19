class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :product
end