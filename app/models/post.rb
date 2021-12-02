class Post < ApplicationRecord
  belongs_to :user, inverse_of: :posts
  has_many :comments, as: :commentable
  has_rich_text :content

  enum status: %i[draft publish deleted spam] # statuses.invert
  COLOR_STATUSES = { draft: 'grey', publish: 'orange', deleted: 'green', spam: 'red' }

  MIN_TITLE_LENGTH = 4
  MAX_TITLE_LENGTH = 120
  MIN_CONTENT_LENGTH = 2

  validates :title, uniqueness: true
  validates :content, :status, presence: true
  validates :title, length: { in: MIN_TITLE_LENGTH..MAX_TITLE_LENGTH }
  validates :content, length: { minimum: MIN_CONTENT_LENGTH } # Action Text > 320 symbol
  validates :status, inclusion: { in: Post.statuses.keys }

  scope :recent, -> { order(created_at: :desc) }
end
