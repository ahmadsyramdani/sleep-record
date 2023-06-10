class Api::UsersController < ApplicationController
  def index
    users = User.all
    render_data(ActiveModel::Serializer::CollectionSerializer.new(users, serializer: UserSerializer), "User list")
  end

  def show
    user = User.find(params[:id])
    render_data(UserSerializer.new(user), "#{user.name} profile")
  end

  def following
    user = User.find(params[:id])
    render_data(ActiveModel::Serializer::CollectionSerializer.new(user.followings, serializer: UserSerializer), "Following list")
  end

  def follower
    user = User.find(params[:id])
    render_data(ActiveModel::Serializer::CollectionSerializer.new(user.followers, serializer: UserSerializer), "Follower list")
  end

  def follow
    user = User.find(params[:id])
    if !@current_user.following?(user)
      action = @current_user.follow(user)
      if action.valid?
        render_success("You are now following #{user.name}")
      else
        render_error(action.errors.full_messages * ', ', :unprocessable_entity)
      end
    else
      render_error("You already follow user #{user.name}", :unprocessable_entity)
    end
  end

  def unfollow
    user = User.find(params[:id])
    if @current_user.following?(user)
      @current_user.unfollow(user)
      render_success("You have unfollowed #{user.name}")
    else
      render_error("You are not following user #{user.name}", :unprocessable_entity)
    end
  end
end
