class User < ApplicationRecord
  has_secure_password
  
  has_many :teams, dependent: :destroy
end
