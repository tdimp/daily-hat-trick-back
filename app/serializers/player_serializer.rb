class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :name, :position, :jersey_number
  
  belongs_to :nhl_team, serializer: NhlTeamSerializer
  
 
end
