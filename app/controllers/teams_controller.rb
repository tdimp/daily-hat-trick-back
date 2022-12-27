class TeamsController < ApplicationController

  def index
    current_user = find_current_user
    render json: current_user.teams
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
    team.update!(team_params)
    render json: team
  end

  def delete
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
