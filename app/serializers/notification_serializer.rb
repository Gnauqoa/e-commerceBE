class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :message, :read, :user_id, :created_at, :updated_at
end
