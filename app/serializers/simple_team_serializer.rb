class SimpleTeamSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_one :user_id
end
