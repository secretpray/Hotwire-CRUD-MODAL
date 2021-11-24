class ApplicationController < ActionController::Base
  # after_action :fix_redirect_code, if: :turbo_stream_redirection?

  def render_flash
    render turbo_stream: turbo_stream.update(:flash, partial: 'shared/flash')
  end
  helper_method :render_flash

  # def turbo_stream_redirection?
  #  request.format.turbo_stream? && response.redirection?
  # end
  #
  # def fix_redirect_code
  #  response.status = 303
  # end
end
