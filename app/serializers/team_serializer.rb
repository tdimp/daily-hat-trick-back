class TeamSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_one :user_id

  has_many :players, serializer: TeamPlayerSerializer
end
