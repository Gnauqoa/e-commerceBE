class Order < ApplicationRecord
  belongs_to :user
  belongs_to :user_discount, optional: true
  belongs_to :discount, optional: true
  has_many :order_items

  enum status: {
    pending: 0,
    completed: 1,
    canceled: 2
  }
end