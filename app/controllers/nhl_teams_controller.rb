class NhlTeamsController < ApplicationController

  def index
    render json: NhlTeam.all
  end

  def show
    team = NhlTeam.find_by(id: params[:id])
    render json: team
  end
end
