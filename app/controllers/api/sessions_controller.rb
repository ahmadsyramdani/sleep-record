class Api::SessionsController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      generate_and_render_api_key(user)
    else
      render_error('Invalid email or password.', :unauthorized)
    end
  end

  def destroy
    @current_user.update(api_key: nil)
    render_success('Logged out successfully.')
  end

  private

  def generate_and_render_api_key(user)
    user.generate_api_key
    render json: {
      api_key: user.api_key,
      message: 'Logged in successfully.'
    }, status: :ok
  end
end
