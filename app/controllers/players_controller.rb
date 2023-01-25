class PlayersController < ApplicationController
  skip_before_action :authorize # Users do not need to be logged in to see Player data.

  def index
    page = params[:page]
    offset = (page.to_i - 1) * 25
    max_pages = (Player.count / 25.0).ceil()
    @players = Player.order(:last_name).limit(25).offset(offset)
    render json: @players  # { players: @players, max_pages: max_pages }
  end

  def show
    player = Player.find_by(id: params[:id])
    render json: player
  end

  def search
    players = Player.all.filter do |p|
      p.full_name.downcase.include? params[:query].downcase
    end
    render json: players.first(25)
  end
end
