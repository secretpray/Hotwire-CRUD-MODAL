class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment

  def show; end

  def edit
    render status: 403 unless @comment.user == current_user
  end

  def update
    render status: 403 unless @comment.user == current_user

    if @comment.update(comment_params)
      flash.now[:notice] = "Comment '#{@comment.id}' updated!"
      redirect_to @comment
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    render status: 403 unless @comment.user == current_user

    @comment.destroy
    flash.now[:notice] = "Comment '#{@comment.id}' destroyed!"
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @comment.commentable }
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end
end
