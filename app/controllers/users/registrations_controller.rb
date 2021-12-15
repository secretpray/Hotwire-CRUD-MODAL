class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!, except: %i[new create]
  before_action :set_user, only: %i(edit update)

  def create
    super
    logger.debug "User #{@user.email} created (in user/RegistrationsController)!"
    User.add_online_user(@user.id)
    update_online_status(@user)
  end

  def edit; end

  def update
    # super
    respond_to do |format|
      logger.debug "User should be valid (users/update registrations): #{@user.valid?}"
      if @user.update(user_params)
        flash.now[:notice] = "User with '#{@user.email}' updated!"
        format.turbo_stream
        format.html { redirect_to account_path(@user) }
      else
        # flash.now[:alert] = @post.errors.full_messages.join('. ')
        format.turbo_stream
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  protected

  def update_resource(resource, params)
    # Require current password if user is trying to change password.
    return super if params["password"]&.present?

    # Allows user to update registration information without password.
    resource.update_without_password(params.except("current_password"))
  end

  def update_online_status(user)
    user.posts.each do |post|
      t = "post_#{post.id}_user_email"
      p = 'users/user_email'
      l = { post: post, online_user_ids: User.online_users }
      # posts index
      post.broadcast_replace_to('posts', target: t, partial: p, locals: l)
      # post show
      post.broadcast_replace_to(post, target: t, partial: p, locals: l)
    end
  end

  private

  def set_user
    @user = current_user
    logger.debug "User attributes hash (users/registrations): #{@user.attributes.inspect}"
  end

  def user_params
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
      params[:user].delete(:current_password)
    end
    params.require(:user).permit(
                                  :id,
                                  :email,
                                  :first_name,
                                  :last_name,
                                  :avatar,
                                  :password,
                                  :password_confirmation)
  end
end
