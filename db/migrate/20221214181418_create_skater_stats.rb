class CreateSkaterStats < ActiveRecord::Migration[7.0]
  def change
    create_table :skater_stats do |t|
      t.integer :season_id
      t.references :player, null: false, foreign_key: true
      t.string :time_on_ice
      t.integer :assists
      t.integer :goals
      t.integer :pim
      t.integer :shots
      t.integer :games
      t.integer :hits
      t.integer :power_play_goals
      t.integer :power_play_points
      t.string :power_play_time_on_ice
      t.float :faceoff_pct
      t.float :shot_pct
      t.integer :game_winning_goals
      t.integer :short_handed_goals
      t.integer :short_handed_points
      t.integer :blocked
      t.integer :plus_minus
      t.integer :points
      t.string :time_on_ice_per_game
      t.string :even_time_on_ice_per_game
      t.string :short_handed_time_on_ice_per_game
      t.string :power_play_time_on_ice_per_game

      t.timestamps
    end
  end
end
