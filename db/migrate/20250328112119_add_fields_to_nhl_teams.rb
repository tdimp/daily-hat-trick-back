class AddFieldsToNhlTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :nhl_teams, :full_name, :string
    add_column :nhl_teams, :tricode, :string
  end
end
