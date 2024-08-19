class UserDiscount < ApplicationRecord
  belongs_to :user
  belongs_to :discount
  belongs_to :order, optional: true

  enum status: {
    avaliable: 1,
    used: 0
  }
end