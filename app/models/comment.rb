class Comment < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :parent, optional: true, class_name: 'Comment'
  has_many :comments, foreign_key: :parent_id, dependent: :destroy
  has_rich_text :body

  validates :body, presence: true

  after_create_commit do
    broadcast_append_to [commentable, :comments], target: "#{dom_id(parent || commentable)}_comments", partial: "comments/comment_with_replies"
    update_comments_counter
    update_post_comments_data
  end

  after_update_commit do
    broadcast_replace_to self
  end

  after_destroy_commit do
    broadcast_remove_to self
    broadcast_action_to self, action: :remove, target: "#{dom_id(self)}_with_comments"
    update_comments_counter
    update_post_comments_data
  end

  private

  def update_comments_counter
    broadcast_update_to [commentable, :comments], target: "#{dom_id(commentable)}_comments_counter", html: "Comment#{commentable.comments.size > 1 ? 's: ' : ': '}#{commentable.comments.size}"
  end

  def update_post_comments_data
    post = self.commentable
    broadcast_update_to 'posts', target: "#{post.id}_comments_info", partial: 'posts/data_comments', locals: { post: post }
    broadcast_update_to commentable, target: "#{post.id}_comments_info", partial: 'posts/data_comments', locals: { post: post }
  end
end
