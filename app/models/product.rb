class Product < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_name, against: [:name]
  pg_search_scope :search_by_description, against: [:description], using: {
    tsearch: { prefix: true }
  }

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true

  def is_available?
    stock > 0
  end

  def self.search(query)
    if query
      search_by_name(query) + search_by_description(query)
    else
      all
    end
  end
end