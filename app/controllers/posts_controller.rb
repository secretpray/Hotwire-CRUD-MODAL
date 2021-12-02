class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  after_action :register_visit, only: :show

  def index
    @posts = Post.recent
  end

  def show
    @comments = @post.comments
  end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        flash.now[:notice] = "Post '#{@post.title}' created!"
        format.turbo_stream
        format.html { redirect_to posts_url }
      else
        # flash.now[:alert] = @post.errors.full_messages.join('. ')
        format.turbo_stream
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        flash.now[:notice] = "Post '#{@post.title}' updated!"
        format.turbo_stream
        format.html { redirect_to posts_url }
      else
        # flash.now[:alert] = @post.errors.full_messages.join('. ')
        format.turbo_stream
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # return unless current_user == @post.user

    @post.destroy
    flash.now[:notice] = "Post '#{@post.title}' destroyed!"
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_url }
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :status, :category, :user_id)
    # params.fetch(:post, {}).permit(:title, :content, :status, :category)
  end

  # Register 3 last viewed posts by current user
  def register_visit
    session[:viewed_posts] ||= []
    session[:viewed_posts] = ([@post.id] + session[:viewed_posts]).uniq.take(3)
  end
end
