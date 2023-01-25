class TeamPlayer < ApplicationRecord
  belongs_to :team
  belongs_to :player

  validates :team_id, :uniqueness => {scope: :player_id}
end
