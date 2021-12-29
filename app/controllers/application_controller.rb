class ApplicationController < ActionController::Base
  # Not needed -> added to config/initializers/pagy.rb
  # include Pagy::Backend
  before_action :configure_permitted_parameters, if: :devise_controller?

  def render_flash
    render turbo_stream: turbo_stream.update(:flash, partial: 'shared/flash')
  end
  helper_method :render_flash

  def update_state(posts)
    render turbo_stream: turbo_stream.replace('posts_counter', html: "Post#{posts.size > 1 ? 's: ' : ': '}#{posts.size}")
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:first_name, :last_name, :avatar, :current_password]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end
end
