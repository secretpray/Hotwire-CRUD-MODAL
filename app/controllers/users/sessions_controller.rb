class Users::SessionsController < Devise::SessionsController
  before_action :remove_user_online, only: :destroy

  def create
    super
    logger.debug "User #{resource.email} created (in user/SessionsController)!"
    User.add_online_user(resource.id)
    update_online_status(resource.id)
  end

  def remove_user_online
    user_id = current_user.id
    logger.debug "User id: #{user_id} signout (in user/SessionsController)!"
    User.remove_online_user(user_id)
    update_online_status(user_id)
  end

  protected

  def update_online_status(user_id)
    user = User.find(user_id)
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
end
