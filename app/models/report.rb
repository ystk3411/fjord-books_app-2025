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

  def update_mentions(text = '')
    text = content if text.blank?
    ids_all_new = extract_local_urls(text)
    ids_to_add = filter_reports_id(ids_all_new, id)
    add_mentioning_reports(self, ids_to_add)
  end

  def extract_local_urls(text)
    local_url_regex = %r{http://127\.0\.0\.1:3000[\w?=&./~:-]*?/(\d+)}
    text.scan(local_url_regex).flatten.map(&:to_i).uniq
  end

  def filter_reports_id(ids_all_new, report_id)
    ids_all_new.reject { |id| id == report_id }
  end

  def add_mentioning_reports(report, ids)
    report.mentioning_report_ids = ids.uniq
  end
end
