class TeamPlayerSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :jersey_number, :position, :goalie_stat, :skater_stat
end
