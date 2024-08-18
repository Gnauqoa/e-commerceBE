class Discount < ApplicationRecord
  has_many :users_discounts

  enum rule: {
    direct: 0,
    next_purchase: 1
  }
  
  enum status: {
    active: 1,
    inactive: 0
  }
end