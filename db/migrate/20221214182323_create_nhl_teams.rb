class CreateNhlTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :nhl_teams do |t|
      t.string :name
      t.string :location_name
      t.string :team_name

      t.timestamps
    end
  end
end
