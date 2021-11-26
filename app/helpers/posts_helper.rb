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
end
