class UsersController < ApplicationController
  before_action :set_user, only: :show

  def show; end

  private

  def set_user
    @user = User.find(params[:id])
    logger.debug "User attributes hash (user controller): #{@user.attributes.inspect}"
  end

end
