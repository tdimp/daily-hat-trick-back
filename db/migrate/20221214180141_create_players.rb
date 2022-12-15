class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :jersey_number
      t.string :position

      t.timestamps
    end
  end
end
