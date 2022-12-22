class Player < ApplicationRecord
  belongs_to :nhl_team

  has_many :team_players
  has_many :teams, through: :team_players
  has_many :goalie_stats
  has_many :skater_stats
end
