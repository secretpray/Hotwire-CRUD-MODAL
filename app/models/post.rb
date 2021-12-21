class Post < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user, inverse_of: :posts
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, dependent: :destroy, inverse_of: :post

  has_rich_text :content

  enum status: %i[draft publish deleted spam]
  COLOR_STATUSES = { draft: 'grey', publish: 'orange', deleted: 'green', spam: 'red' }

  MIN_TITLE_LENGTH = 4
  MAX_TITLE_LENGTH = 120
  MIN_CONTENT_LENGTH = 2

  validates :title, uniqueness: true
  validates :content, :status, presence: true
  validates :title, length: { in: MIN_TITLE_LENGTH..MAX_TITLE_LENGTH }
  validates :content, length: { minimum: MIN_CONTENT_LENGTH }
  validates :status, inclusion: { in: Post.statuses.keys }

  scope :commented, -> { order('comments_count') }  # Post.commented.pluck(:id, :comments_count)
  scope :liked, -> { order('likes_count') }         # Post.liked.pluck(:id, :likes_count)

  def self.sort(selection)
    case selection.join('')
    when 'new'
      order(created_at: :desc)
    when 'old'
      order(created_at: :asc)
    when 'likes'
      order(likes_count: :desc)
      # list_sort('like', 'desc')
    when 'dislikes'
      order(likes_count: :asc)
      # list_sort('like', 'asc')
    when 'commentes'
      order(comments_count: :desc)
      # list_sort('comment', 'desc')
    when 'uncommentes'
      order(comments_count: :asc)
      # list_sort('comment', 'asc')
    else
      Post.recent
    end
  end

  def liked?(user)
    Like.where(post: self, user: user).any?
  end

  def update_like(user)
    if liked?(user)
      user.likes.find_by(post: self).destroy
    else
      user.likes.create(post_id: self.id)
    end
  end

  after_create_commit do
    broadcast_prepend_to 'posts', target: 'post_list',  partial: 'posts/post_brc', locals: { post: self, online_user_ids: User.online_users }
    update_posts_counter
  end

  after_update_commit do
    broadcast_replace_to self, partial: 'posts/post_brc', locals: { post: self, online_user_ids: User.online_users } # for broadcast with likes
  end

  after_destroy_commit do
    broadcast_remove_to self
    update_posts_counter
  end

  private

  def update_posts_counter
    broadcast_update_to 'posts', target: 'posts_counter', html: "Post#{Post.all.size > 1 ? 's: ' : ': '}#{Post.all.size}"
  end

  # def list_sort(model, direction)
  #   klass = model.classify.constantize
  #   sorted = find(klass.group(:post_id).order(Arel.sql("count(post_id) #{direction}")).pluck(:post_id))
  #   other = (Post.all - sorted).sort.reverse
  #   sorted + other
  # end
end
