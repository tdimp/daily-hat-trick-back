class User < ApplicationRecord
  has_secure_password
  
  has_many :teams, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
