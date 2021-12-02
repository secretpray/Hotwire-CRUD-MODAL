module Commentable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  def create
    @comment = @commentable.comments.build(comments_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @commentable }
      else
        format.turbo_stream {}
        format.html { redirect_to @commentable }
      end
    end
  end

  private

  def comments_params
    params.require(:comment).permit(:body, :parent_id)
  end
end
