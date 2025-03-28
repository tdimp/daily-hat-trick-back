class RemoveFieldsFromNhlTeams < ActiveRecord::Migration[7.0]
  def change
    remove_column :nhl_teams, :location_name, :string
    remove_column :nhl_teams, :team_name, :string
  end
end
