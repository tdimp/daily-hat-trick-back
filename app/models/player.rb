class Player < ApplicationRecord
  belongs_to :nhl_team

  has_many :team_players
  has_many :teams, through: :team_players
  has_one :skater_stat
  has_one :goalie_stat
  
end
