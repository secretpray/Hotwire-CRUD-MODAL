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

  def set_title(item)
    return unless item.downcase.in?(Post::SORTED_METHODS) || item.is_a?(String)

    if item.downcase.end_with?('likes')
      Post::SORTED_TITLES.first
    elsif item.downcase.end_with?('commentes')
      Post::SORTED_TITLES.second
    else
      Post::SORTED_TITLES.third
    end
  end

  def decode_sort_method(sorted_value)
    return 'none' unless sorted_value.in?(Post::SORTED_METHODS) || sorted_value.is_a?(String)

    direction =
      if sorted_value === 'new' || sorted_value === 'likes' || sorted_value === 'commentes'
        '&nbsp; <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mt-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13l-3 3m0 0l-3-3m3 3V8m0 13a9 9 0 110-18 9 9 0 010 18z" />
        </svg>'
      elsif sorted_value === 'old' || sorted_value === 'dislikes' || sorted_value === 'uncommentes'
        '&nbsp; <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mt-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 11l3-3m0 0l3 3m-3-3v8m0-13a9 9 0 110 18 9 9 0 010-18z" />
        </svg>'
      end

    title = set_title(sorted_value).downcase
    title + direction
  end
end
