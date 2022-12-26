class Team < ApplicationRecord
  belongs_to :user

  has_many :team_players, dependent: :delete_all
  has_many :players, through: :team_players
end
