class Avo::Resources::Discount < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :percentage, as: :number
    field :start_date, as: :datetime
    field :end_date, as: :datetime
    field :rule, as: :number
    field :stock, as: :number
    field :quantity, as: :number
    field :status, as: :number
    field :created_at, as: :datetime
    field :updated_at, as: :datetime
    field :total_require, as: :number
  end
end
