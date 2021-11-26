class ApplicationController < ActionController::Base
  # after_action :fix_redirect_code, if: :turbo_stream_redirection?
  before_action :configure_permitted_parameters, if: :devise_controller?

  def render_flash
    render turbo_stream: turbo_stream.update(:flash, partial: 'shared/flash')
  end
  helper_method :render_flash

  protected

  def configure_permitted_parameters
    added_attrs = [:first_name, :last_name, :avatar]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  # def turbo_stream_redirection?
  #  request.format.turbo_stream? && response.redirection?
  # end
  #
  # def fix_redirect_code
  #  response.status = 303
  # end
end
