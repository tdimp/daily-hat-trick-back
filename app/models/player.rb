class Player < ApplicationRecord
  belongs_to :nhl_team

  has_many :team_players
  has_many :teams, through: :team_players
  has_many :goalie_stats
  has_many :skater_stats

  def stats
    player = Player.find_by(id: params[:id])
    if player.position != "G"
      return player.skater_stats
    elsif player.position == "G"
      return player.goalie_stats
    else
      return "Player has no stats"
    end
  end
end
