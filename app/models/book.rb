# frozen_string_literal: true

class Book < ApplicationRecord
  paginates_per 5
  mount_uploader :picture, PictureUploader
end
