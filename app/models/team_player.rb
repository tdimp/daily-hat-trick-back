class TeamPlayer < ApplicationRecord
  belongs_to :team_id
  belongs_to :player_id
end
