class Post < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user, inverse_of: :posts
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, dependent: :destroy, inverse_of: :post
  has_rich_text :content

  enum status: %i[draft publish deleted spam]

  SORTED_METHODS      = %w(new old likes dislikes commentes uncommentes).freeze
  SORTED_TITLES       = ['By rating', 'By popularity', 'By date'].freeze
  COLOR_STATUSES      = { draft: 'grey', publish: 'orange', deleted: 'green', spam: 'red' }
  MIN_TITLE_LENGTH    = 4
  MAX_TITLE_LENGTH    = 120
  MIN_CONTENT_LENGTH  = 2

  validates :title, uniqueness: true
  validates :content, :status, presence: true
  validates :title, length: { in: MIN_TITLE_LENGTH..MAX_TITLE_LENGTH }
  validates :content, length: { minimum: MIN_CONTENT_LENGTH }
  validates :status, inclusion: { in: Post.statuses.keys }

  scope :with_title_category_containing, ->(query) { where("title ilike ? OR category ilike ?", "%#{query}%","%#{query}%") }
  scope :with_content_containing, ->(query) { joins(:rich_text_content).merge(ActionText::RichText.where('body ILIKE ?', "%#{query}%")) }
  scope :multi_records_containing, -> (query) {
     joins(:rich_text_content).merge(ActionText::RichText.where('title ILIKE ? OR category ILIKE ? OR body ILIKE ?', "%#{query}%","%#{query}%","%#{query}%"))
  }
  scope :yesterday, -> { where('created_at < ? AND created_at > ?', Time.zone.now, Date.today.beginning_of_day) }
  scope :yesterday_deleted, -> { where(status: :deleted).where('created_at < ? AND created_at > ?', Time.zone.now, Date.today.beginning_of_day) }
  scope :last_week, -> { where('created_at < ? AND created_at > ?', Time.zone.now, Date.today.beginning_of_week) }
  scope :last_week_deleted, -> { where(status: :deleted).where('created_at < ? AND created_at > ?', Time.zone.now, Date.today.beginning_of_week) }
  scope :last_month, -> { where('created_at < ? AND created_at > ?', Time.zone.now, Date.today.beginning_of_month) }
  scope :last_month_deleted, -> { where(status: :deleted).where('created_at < ? AND created_at > ?', Time.zone.now, Date.today.beginning_of_month) }
  scope :commented, -> { order('comments_count') }
  scope :liked, -> { order('likes_count') }

  # Save sorted method
  def self.saved_sort
    @sort_list ||= Kredis.string "sort_list"
  end

  def self.get_saved_sort
    Post.saved_sort if @sort_list.nil?
    @sort_list.value
  end

  def self.set_saved_sort(sort_method)
    Post.saved_sort if @sort_list.nil?
    sort_method = sort_method.in?(SORTED_METHODS) ? sort_method : ''

    @sort_list.value = sort_method
  end

  def self.make_sort(selection, list)
    selection = selection.is_a?(Array) ? selection.join('') : selection

    case selection
    when 'new'
      Post.set_saved_sort('new')
      list.order(created_at: :desc)
    when 'old'
      Post.set_saved_sort('old')
      list.order(created_at: :asc)
    when 'likes'
      Post.set_saved_sort('likes')
      list.order(likes_count: :desc)
    when 'dislikes'
      Post.set_saved_sort('dislikes')
      list.order(likes_count: :asc)
    when 'commentes'
      Post.set_saved_sort('commentes')
      list.order(comments_count: :desc)
    when 'uncommentes'
      Post.set_saved_sort('uncommentes')
      list.order(comments_count: :asc)
    else
      list.recent
    end
  end

  # def self.parse_filter_params(params)
  #   case
  #   when !params[:filter_name].blank?
  #     @users = User.where('name ILIKE ? OR email ILIKE ?', "%#{params[:filter_name]}%", "%#{params[:filter_name]}%")
  #     # @users = result.includes(:team, :user)
  #     #               .where('name ILIKE ? OR description ILIKE ?', "%#{params[:filter_name]}%", "%#{params[:filter_name]}%")
  #   # when !params[:description].blank?
  #   #   @ingredients = Bio.joins(:action_text_rich_text)
  #   #                       .where("action_text_rich_texts.body ILIKE ?", "%#{params[:description]}%")
  #   #   @recipes = Recipe.joins(:ingredients).where("ingredients.id" => @ingredients)
  # when !params[:age].blank?
  #     @users = @users.where("age LIKE ?", "%#{params[:age]}%")
  #   else
  #     @users = @users.includes(:team)
  #   end
  # end

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
    # binding.pry
    broadcast_remove_to self
    update_posts_counter
  end

  private

  def update_posts_counter
    broadcast_update_to 'posts', target: 'posts_counter', partial: 'posts/posts_counter', locals: { count: Post.count }
  end
end
