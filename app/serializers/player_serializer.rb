class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :position, :jersey_number
  
  belongs_to :nhl_team, serializer: NhlTeamSerializer

  has_one :skater_stat
  has_one :goalie_stat
 
end
