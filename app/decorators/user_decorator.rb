# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate_all

  def jwt_payload
    {
      user: {
        id:,
        username:,
        email:,
        first_name:,
        last_name:
      },
      exp: (Time.current + 15.days).to_i
    }
  end
end
