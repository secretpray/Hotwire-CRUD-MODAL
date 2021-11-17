module PostsHelper

  def status_color(status)
    Post::COLOR_STATUSES[status.to_sym] || 'grey'
  end
end
