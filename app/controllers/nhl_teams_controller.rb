class NhlTeamsController < ApplicationController
  skip_before_action :authorize # Users do not need to be logged in to see NHL team and roster data.

  def index
    render json: NhlTeam.all
  end

  def show
    team = NhlTeam.find(params[:id])
    render json: team, serializer: NhlTeamShowSerializer
  end
end
