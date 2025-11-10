class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  # Associations
  has_many :posts, dependent: :destroy
  has_many :hoorays, dependent: :destroy

  # Validations
  validates :jti, presence: true

  # Callbacks
  before_validation :generate_jti, on: :create

  private

  def generate_jti
    self.jti = SecureRandom.uuid
  end
end
