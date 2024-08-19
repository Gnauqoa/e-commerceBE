class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :price, :product_metadata, :created_at, :updated_at

  def product_metadata
    JSON.parse(object.product_metadata)
  end
end