class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :user_like]
  before_action :auth_post, only: [:edit, :update, :destroy]

  def index
    @posts = Post.recent
  end

  def show; end

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
        format.turbo_stream
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    flash.now[:notice] = "Post '#{@post.title}' destroyed!"
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_url }
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
      format.turbo_stream # rendered in posts/user_like.turbo_stream.erb
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
end
