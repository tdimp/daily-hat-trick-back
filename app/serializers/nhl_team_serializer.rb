class NhlTeamSerializer < ActiveModel::Serializer
  attributes :name

  has_many :players
end
