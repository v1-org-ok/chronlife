class FriendshipResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  # Fields generated from the model
  field :account_id, as: :text
  field :friend_id, as: :text
  field :account, as: :belongs_to
  field :friend, as: :belongs_to
  # add fields here
end
