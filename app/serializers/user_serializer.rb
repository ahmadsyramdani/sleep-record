class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :follower_count, :following_count, :created_at, :updated_at  
end
