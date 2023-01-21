class TeamsController < ApplicationController

  def index
    current_user = find_current_user
    render json: current_user.teams, each_serializer: SimpleTeamSerializer # This serializer prevents nested player data from being serialized
  end

  def show
    current_user = find_current_user
    team = current_user.teams.find_by(id: params[:id])
    render json: team
  end
  
  def create
    current_user = find_current_user
    team = current_user.teams.create!(team_params)
    render json: team
  end

  def update
    team = find_team
    team.update(team_params)
    render json: team
  end

  def drop_player # Need to make this add/remove players from team.
    team = find_team
    player = Player.find(params[:droppedId])
    team.players.delete(player)
    render json: team
  end

  def add_player
    team = find_team
    player = Player.find(params[:addedId])
    team.players << player
    render json: player
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
