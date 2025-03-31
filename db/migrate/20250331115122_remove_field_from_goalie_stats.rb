class RemoveFieldFromGoalieStats < ActiveRecord::Migration[7.0]
  def change
    remove_column :goalie_stats, :time_on_ice_per_game, :string
  end
end
