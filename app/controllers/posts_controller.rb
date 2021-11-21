class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.recent
  end

  def show; end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    @post = Post.new(post_params)
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
    params.require(:post).permit(:title, :content, :status, :category)
    # params.fetch(:post, {}).permit(:title, :content, :status, :category)
  end
end
