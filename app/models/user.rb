class User < ApplicationRecord
  has_secure_password

  def generate_api_key
    self.api_key = SecureRandom.hex(32)
    self.save!
  end
end
