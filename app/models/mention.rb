# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :sender, class_name: 'Report'
  belongs_to :receiver, class_name: 'Report'
end
