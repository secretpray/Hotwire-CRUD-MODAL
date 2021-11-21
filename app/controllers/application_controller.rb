class ApplicationController < ActionController::Base
  def render_flash
    render turbo_stream: turbo_stream.update(:flash, partial: 'shared/flash')
  end
  helper_method :render_flash
end
