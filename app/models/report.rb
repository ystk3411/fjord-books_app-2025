# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :passive_mentions, class_name: 'Mention', foreign_key: 'receiver_id', dependent: :destroy, inverse_of: :receiver
  has_many :mentioning_reports, through: :passive_mentions, source: :sender
  has_many :active_mentions, class_name: 'Mention', foreign_key: 'sender_id', dependent: :destroy, inverse_of: :sender
  has_many :mentioned_reports, through: :active_mentions, source: :receiver

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
