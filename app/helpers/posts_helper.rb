module PostsHelper

  def status_color(status)
    Post::COLOR_STATUSES[status.to_sym] || 'grey'
  end

  def truncated_title(title, controller_name, action_name)
    if controller_name == 'posts' && action_name == "show"
      title
    else
      truncate(title, length: 42, separator: ' ')
    end
  end

  def comments_user_data(post)
    comments_count = post.comments.count
    comment_users =  User.find(post.comments.pluck(:user_id).uniq)
    users_avatar = comment_users.map{|user| AvatarPresenter.call(user, 40)}

    return { count: comments_count, users_avatar: users_avatar.join(' ') }
  end
end
