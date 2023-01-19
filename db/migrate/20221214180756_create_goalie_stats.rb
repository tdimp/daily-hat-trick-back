class CreateGoalieStats < ActiveRecord::Migration[7.0]
  def change
    create_table :goalie_stats do |t|
      t.integer :season_id
      t.references :player, null: false, foreign_key: true
      t.string :time_on_ice
      t.integer :ot
      t.integer :shutouts
      t.integer :wins
      t.integer :losses
      t.integer :saves
      t.float :save_percentage
      t.float :goals_against_average
      t.float :power_play_save_percentage
      t.float :short_handed_save_percentage
      t.float :even_strength_save_percentage
      t.integer :games
      t.integer :games_started
      t.integer :shots_against
      t.integer :goals_against
      t.string :time_on_ice_per_game

      t.timestamps
    end
  end
end
