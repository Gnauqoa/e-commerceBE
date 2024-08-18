# frozen_string_literal: true

class ArtistDecorator < Draper::Decorator
  delegate_all

  def jwt_payload
    {
      artist: {
        id:,
        email:,
        name:
      },
      exp: (Time.current + 15.days).to_i
    }
  end
end
