class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :user_like]
  before_action :auth_post, only: [:edit, :update, :destroy]
  before_action :get_online_user_id, only: %i[index show update]

  def index
    query = params[:query]
    current_user.recent_searches.prepend(query) unless query.blank?
    # make Search
    posts = query.blank? ? Post.all : Post.sanitize_multi_search(query)
    # make Sort
    if params[:sort].present?
      posts_unpaged = Post.make_sort(params[:sort], posts)
    else
      get_sort = Post.get_saved_sort
      posts_unpaged = get_sort.in?(Post::SORTED_METHODS) ? Post.make_sort(get_sort, posts) : posts.recent
    end
    # make Pagination
    @page, @posts = pagy(posts_unpaged, items: 10)
    # fetch saved sort params (from Redis DB)
    @sorted_value = Post.get_saved_sort
    # fetch saved searches User history (from Redis DB)
    @histories = current_user.recent_searches.elements
    # update user search list
    current_user.update_user_search_history(@histories) unless query.blank?
    # select method for render TURBO_STREAM (index.turbo_stream.erb)
    @endless_render = params[:endless].present?
    # remove blank params (if 'endless' = '')
    params.delete(:endless) if params[:endless].blank?
  end

  def show; end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    @post = current_user.posts.build(post_params)

    flash.now[:notice] = "Post '#{@post.title}' created!" if @post.save
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        flash.now[:notice] = "Post '#{@post.title}' updated!"
        format.turbo_stream
      else
        format.turbo_stream
      end
    end
  end

  def destroy
    @post.destroy
    flash.now[:notice] = "Post '#{@post.title}' destroyed!"
    respond_to do |format|
      format.turbo_stream
    end
  end

  def like
    @post.update_like(current_user)
    flash.now[:notice] = "Thank you for rating!"

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update(:flash, partial: 'shared/flash') }
      format.html { redirect_to posts_url }
    end
  end

  def user_like
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :status, :category, :user_id)
  end

  def auth_post
    render status: 403 unless @post.user == current_user
  end

  def get_online_user_id
    @online_user_ids = User.online_users
  end
end
