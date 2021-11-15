class Post < ApplicationRecord

  enum status: %i[draft published deleted banned] # statuses.invert

  MIN_TITLE_LENGTH = 4
  MAX_TITLE_LENGTH = 120
  MIN_CONTENT_LENGTH = 2
  MAX_CONTENT_LENGTH = 320

  validates :title, uniqueness: true
  validates :content, :status, presence: true
  validates :title, length: { in: MIN_TITLE_LENGTH..MAX_TITLE_LENGTH }
  validates :content, length: { in: MIN_CONTENT_LENGTH..MAX_CONTENT_LENGTH}
  validates :status, inclusion: { in: Post.statuses.keys }
end
