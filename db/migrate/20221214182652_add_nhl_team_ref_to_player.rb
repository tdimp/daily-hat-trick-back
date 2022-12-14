class AddNhlTeamRefToPlayer < ActiveRecord::Migration[7.0]
  def change
    add_reference :players, :nhl_team, null: false, foreign_key: true
  end
end
