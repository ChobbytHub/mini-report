class Post < ApplicationRecord
  belongs_to :user
  has_many :hoorays, dependent: :destroy

  validates :content, presence: true, length: { maximum: 500 }
end
