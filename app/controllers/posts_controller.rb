class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :user_like]
  before_action :auth_post, only: [:edit, :update, :destroy]
  after_action :register_visit, only: :show

  def index
    @posts = Post.recent
  end

  def show; end

  def new
    @post = Post.new
  end

  def edit; end
  # This hack not need (for edit only) in stable version Turbo
  # format.turbo_stream { render turbo_stream: turbo_stream.update(@post, partial: 'posts/form', locals: { post: @post })}

  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        flash.now[:notice] = "Post '#{@post.title}' created!"
        format.turbo_stream
        # format.turbo_stream do
        #   render turbo_stream: [
        #     turbo_stream.update('new_post', partial: 'posts/form', locals: { post: Post.new }),
        #     turbo_stream.prepend('posts', partial: 'posts/post', locals: { post: @post })
        #     turbo_stream.update('posts_counter', "Post#{Post.all.size > 1 ? 's: ' : ': '}#{Post.all.size}" )
        #     other variant
        #     # turbo_stream.update('posts_counter', html: posts_counter.html_safe)
        #   ]
        # end
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
        format.turbo_stream {}
        # format.turbo_stream { render turbo_stream: turbo_stream.update(@post, partial: 'posts/post', locals: { ipost: @post }) }
        format.html { redirect_to posts_url }
      else
        format.turbo_stream {}
        # format.turbo_stream { render turbo_stream: turbo_stream.update(@post, partial: 'posts/form', locals: { post: @post }) }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    flash.now[:notice] = "Post '#{@post.title}' destroyed!"
    respond_to do |format|
      format.turbo_stream {}
      # # format.turbo_stream { render turbo_stream: turbo_stream.remove(@post) }
      # or with counter ->
      # format.turbo_stream do
      #   render turbo_stream: [
      #     turbo_stream.update('posts_counter', html: "#{Inbox.count}"),
      #     turbo_stream.remove(@post)
      #   ]
      # end
      format.html { redirect_to posts_url }
    end
  end

  def like
    @post.update_like(current_user)
    flash.now[:notice] = "Thank you for rating!"

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update(:flash, partial: 'shared/flash') }
        # render turbo_stream: [
        #   turbo_stream.update('posts', "#{@post.id}_like", partial: 'posts/likes', locals: { post: @post}),
        #   turbo_stream.update(:flash, partial: 'shared/flash')
        # ]
      # }

      # format.turbo_stream {
      #   render turbo_stream: [
      #     turbo_stream.replace(@posts, target: "#{@post.id}_like", partial: 'posts/likes', locals: { post: @post })
      #     turbo_stream.replace(@posts, target: "#{@post.id}_like", partial: 'posts/likes_brc', locals: { post: @post})
      #   ]
      # }
      format.html { redirect_to posts_url }
    end
  end

  def user_like
    respond_to do |format|
      format.turbo_stream # rendered in posts/user_like.turbo_stream.erb
      # format.turbo_stream { render turbo_stream: turbo_stream.update("#{@post.id}_like", partial: 'posts/likes', locals: { post: @post}) }
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

  def auth_post
    render status: 403 unless @post.user == current_user
  end
  # Register 3 last viewed posts by current user
  def register_visit
    session[:viewed_posts] ||= []
    session[:viewed_posts] = ([@post.id] + session[:viewed_posts]).uniq.take(3)
  end

  # def posts_counter
  #   "Post#{Post.all.size > 1 ? 's: ' : ': '}#{Post.all.size}"
  # end
end
