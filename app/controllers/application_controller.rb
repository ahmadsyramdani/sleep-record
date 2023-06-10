class ApplicationController < ActionController::API
  before_action :authorize_request

  private

  def authorize_request
    @current_user = find_user_by_api_key
    render json: { error: 'Invalid API key' }, status: :unauthorized unless @current_user
  end

  def find_user_by_api_key
    api_key = extract_api_key
    User.find_by(api_key: api_key) if api_key
  end

  def extract_api_key
    pattern = /^Bearer /
    header = request.headers['Authorization']
    header.gsub(pattern, '') if header&.match(pattern)
  end
end
