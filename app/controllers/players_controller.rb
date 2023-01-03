class PlayersController < ApplicationController
  skip_before_action :authorize # Users do not need to be logged in to see Player data.

  def index
    page = params[:page]
    @players = Player.order(created_at: :desc).limit(10).offset((page.to_i - 1) * 10)
    render json: @players
  end

  def show
    player = Player.find_by(name: params[:name])
    render json: player
  end

  def stats
    player = Player.find_by(id: params[:player_id])
    if player.position == 'G'
      render json: player.goalie_stats
    else
      render json: player.skater_stats
    end
  end
end
