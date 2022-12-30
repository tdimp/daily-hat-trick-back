class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :name, :position, :jersey_number

  has_one :nhl_team
end
