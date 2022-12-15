class PlayersController < ApplicationController

  def index
    render json: Player.all
  end

  def show
    player = Player.find_by(name: params[:name])
    render json: player
  end
end
