class Comment < ApplicationRecord
  include ActionView::RecordIdentifier
  include ActionView::Helpers::TextHelper

  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :parent, optional: true, class_name: 'Comment'
  has_many :comments, foreign_key: :parent_id, dependent: :destroy
  has_rich_text :body

  MAX_NESTING_DEPTH = 3

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

  def set_nesting
    if self.parent.present? && self.parent.nesting.present?
      self.nesting = self.parent.nesting + 1
    else
      self.nesting = 1
    end
  end

  def self.max_nesting
    MAX_NESTING_DEPTH
  end

  private

  def update_comments_counter
    broadcast_update_to [commentable, :comments], target: "#{dom_id(commentable)}_comments_counter",
                        html: "#{pluralize(commentable.comments.size, 'Comment').split().reverse.join(': ')}"
  end

  def update_post_comments_data
    post = self.commentable
    broadcast_update_to 'posts', target: "#{post.id}_comments_info", partial: 'posts/data_comments', locals: { post: post }
    broadcast_update_to commentable, target: "#{post.id}_comments_info", partial: 'posts/data_comments', locals: { post: post }
  end
end
