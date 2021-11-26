module UsersHelper
  def user_avatar(user, size=40)
    if user.avatar.attached?
      image_tag user.avatar.variant(resize: "#{size}x#{size}!"), class: 'rounded-full'
    else
      avatar_circle(user, size)
      # gravatar_image_url(user.email, size: size)
    end
  end

  def avatar_circle(user, size)
    if gravatar_exists?(user.email)
      image_tag gravatar_image_url(user.email, size: size), class: 'rounded-full'
      # gravatar_id = Digest::MD5.hexdigest(user.email)
      # gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
      # image_tag(gravatar_url, class: 'avatar_circle')
    else
      # inline_svg_pack_tag('media/images/user.svg', class: "rounded", size: "5rem * 5rem")
      initials = [user.first_name.first, user.last_name.first].join('')
      style = "background-color: #{avatar_color(initials)}; height: #{size}px; width: #{size}px;"
      content_tag :div, class: 'avatar-circle', style: style do
        content_tag :div, initials, class: 'avatar-text'
      end
    end
  end

  def gravatar_exists?(email)
    hash = Digest::MD5.hexdigest(email)
    http = Net::HTTP.new('www.gravatar.com', 80)
    http.read_timeout = 2
    response = http.request_head("/avatar/#{hash}?default=http://gravatar.com/avatar")
    response.code != '302' ? true : false
  rescue StandardError, Timeout::Error
    false
  end

  def avatar_color(initials)
    colors = [
      '#00AA55', '#009FD4', '#B381B3', '#939393', '#E3BC00',
      '#047500', '#DC2A2A', '#696969', '#ff0000', '#ff80ed',
      '#407294', '#133337', '#065535', '#c0c0c0', '#5ac18e',
      '#666666', '#f7347a', '#576675', '#696966', '#008080',
      '#ffa500', '#40e0d0', '#8000ff', '#003366', '#fa8072',
      '#800000'
    ]

    colors[initials.first.to_s.downcase.ord - 97] || '#000000'
  end

end
