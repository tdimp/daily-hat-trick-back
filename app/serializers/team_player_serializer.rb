class TeamPlayerSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :position, :goalie_stat, :skater_stat
end
