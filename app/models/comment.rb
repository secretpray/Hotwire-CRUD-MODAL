class Comment < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_rich_text :body

  validates :body, presence: true

  after_create_commit do
    broadcast_append_to [commentable, :comments], target: "#{dom_id(commentable)}_comments"
    update_comments_counter
  end

  after_update_commit do
    broadcast_replace_to self
  end

  after_destroy_commit do
    broadcast_remove_to self
    update_comments_counter
  end

  private

  def update_comments_counter
    broadcast_update_to [commentable, :comments], target: "#{dom_id(commentable)}_comments_counter", html: "Comment#{commentable.comments.size > 1 ? 's: ' : ': '}#{commentable.comments.size}"
  end
end
