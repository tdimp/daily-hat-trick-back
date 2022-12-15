class Player < ApplicationRecord
  belongs_to :nhl_team

  has_many :team_players
  has_many :teams, through: :team_players
end
