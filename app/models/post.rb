class Post < ApplicationRecord
  has_rich_text :content
  # has_many_attached :images

  enum status: %i[draft publish deleted spam] # statuses.invert
  COLOR_STATUSES = { draft: 'grey', publish: 'orange', deleted: 'green', spam: 'red' }

  MIN_TITLE_LENGTH = 4
  MAX_TITLE_LENGTH = 120
  MIN_CONTENT_LENGTH = 2
  MAX_CONTENT_LENGTH = 320

  validates :title, uniqueness: true
  validates :content, :status, presence: true
  validates :title, length: { in: MIN_TITLE_LENGTH..MAX_TITLE_LENGTH }
  validates :content, length: { minimum: MIN_CONTENT_LENGTH } # Action Text > 320 symbol
  # validates :content, length: { in: MIN_CONTENT_LENGTH..MAX_CONTENT_LENGTH}
  validates :status, inclusion: { in: Post.statuses.keys }

end
