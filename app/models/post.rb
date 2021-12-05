class Post < ApplicationRecord
  belongs_to :user, inverse_of: :posts
  has_many :comments, as: :commentable, dependent: :destroy
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

  # broadcasts
  # broadcasts_to ->(post) { :posts }
  # after_update_commit { broadcast_replace_later_to 'posts' }

  # for use with current_user
  # after_update_commit -> { broadcast_replace_later_to(self, locals: { user: current_user, post: self }) }
  # for use with current_user and fixed bug in Console
  # after_update_commit do
    # defined?(current_user) ? broadcast_replace_later_to(self, locals: { user: current_user, post: self }) : nil
    # current_user ? broadcast_replace_later_to(self, locals: { user: current_user, post: self }) : nil
  # end
end
