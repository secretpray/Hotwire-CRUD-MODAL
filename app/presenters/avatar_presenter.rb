class AvatarPresenter
  include ActionView::Context
  include ActionView::Helpers::AssetTagHelper
  include Rails.application.routes.url_helpers

  def self.call(user, size)
    new(user, size).call # AvatarPresenter.new(user).call -> AvatarPresenter.call(user)
  end

  attr_accessor :user, :size

  def initialize(user, size = 40)
    @user = user
    @size = size
  end

  def call
    if avatar.attached?
      image_tag polymorphic_url(avatar.variant(resize: "#{size}x#{size}!"), only_path: true), class: 'rounded-full transform hover:scale-125 cursor-pointer'
    else
      avatar_circle
    end
  end

  def avatar_circle
    if gravatar_exists?
      gravatar_image
    else
      initials_element
    end
  end

  private

  def gravatar_exists?
    hash = Digest::MD5.hexdigest(email)
    http = Net::HTTP.new('www.gravatar.com', 80)
    http.read_timeout = 2
    response = http.request_head("/avatar/#{hash}?default=http://gravatar.com/avatar")
    response.code != '302' ? true : false
  rescue StandardError, Timeout::Error
    false
  end

  def gravatar_image
    # image_tag gravatar_image_url(email, size: size), class: 'rounded-full'
    gravatar_id = Digest::MD5.hexdigest(email)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, size: size, class: 'rounded-full transform hover:scale-125 cursor-pointer')
  end

  def initials_element
    style = "background-color: #{avatar_color(initials.first)}; height: #{size}px; width: #{size}px;"
    content_tag :div, class: 'h-10 w-10 transform hover:scale-110 rounded-full relative', style: style do
      content_tag :div, initials, class: 'avatar-text cursor-pointer'
    end
  end

  def email
    user.email
  end

  def avatar
    user.avatar
  end

  def name
    [user.first_name, user.last_name].join(' ')
  end

  def initials
    unless name.blank?
      name.split.first(2).map(&:first).join
    else
      email.gsub(/[[-.][_.]]+/, '').first(2)
    end
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
