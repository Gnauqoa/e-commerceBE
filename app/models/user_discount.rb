class UserDiscount < ApplicationRecord
  belongs_to :user
  belongs_to :discount
end