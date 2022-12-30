class Player < ApplicationRecord
  belongs_to :nhl_team

  has_many :team_players
  has_many :teams, through: :team_players
  has_many :goalie_stats
  has_many :skater_stats

  def self.stats
    if self.position != "G"
      return serialize :self.skater_stats
    elsif self.position == "G"
      return self.goalie_stats
    else
      return "Player has no stats"
    end
  end
end
