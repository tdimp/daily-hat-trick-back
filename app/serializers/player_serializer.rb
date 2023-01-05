class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :position, :jersey_number
  
  belongs_to :nhl_team, serializer: NhlTeamSerializer

  has_many :goalie_stats
  has_many :skater_stats
 
end
