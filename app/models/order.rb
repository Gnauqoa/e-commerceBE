class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items

  enum status: {
    pending: 0,
    completed: 1,
    canceled: 2
  }
end