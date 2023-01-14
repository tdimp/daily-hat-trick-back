class TeamsController < ApplicationController

  def index
    current_user = find_current_user
    render json: current_user.teams
  end

  def show
    current_user = find_current_user
    team = current_user.teams.find_by(id: params[:id])
    render json: team.players
  end
  
  def create
    current_user = find_current_user
    team = current_user.teams.create!(team_params)
    render json: team
  end

  def update # Need to make this update team name only and add a different controller action for adding/removing players from team.
    team = find_team
    player = Player.find(params[:droppedId])
    team.players.delete(player)
    render json: team
  end

  def destroy
    team = find_team
    team.destroy
    head :no_content
  end


  private

  def find_current_user
    current_user = User.find(session[:user_id])
  end

  def find_team
    team = find_current_user.teams.find(params[:id])
  end

  def team_params
    params.permit(:name, :user_id)
  end
end
