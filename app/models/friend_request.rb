# == Schema Information
#
# Table name: friend_requests
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :uuid             not null
#  friend_id  :uuid             not null
#
# Indexes
#
#  index_friend_requests_on_account_id  (account_id)
#  index_friend_requests_on_friend_id   (friend_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (friend_id => accounts.id)
#
# Info:
#
# Account is a person who sent a friend request.
# Friend is a person who received a friend request.
#
# :account -> :friend
#
# If we select all friend requests by :account, we will get all sent friend requests.
# If we select all friend requests by :friend, we will get all received friend requests.
#
class FriendRequest < ApplicationRecord
  belongs_to :account
  belongs_to :friend, class_name: "Account"

  validates :account_id, uniqueness: { scope: :friend_id }
  validate :not_friends
  validate :not_pending
  validate :not_self

  def accept
    account.friends << friend
    destroy
  end

  private

  def not_self
    errors.add(:friend, "can't be equal to user") if account == friend
  end

  def not_friends
    errors.add(:friend, "is already added") if account.friends.include?(friend)
  end

  def not_pending
    errors.add(:friend, "already requested friendship") if friend.sent_friend_requests.any?
  end
end
