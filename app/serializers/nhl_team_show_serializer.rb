class NhlTeamShowSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :players, serializer: TeamPlayerSerializer
end
