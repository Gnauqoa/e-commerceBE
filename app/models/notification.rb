class Notification
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message, type: String
  field :read, type: Boolean, default: false
  field :user_id, type: Integer

  def user 
    User.find(user_id)  
  end
end
