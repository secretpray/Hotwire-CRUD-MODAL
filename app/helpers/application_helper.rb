module ApplicationHelper
  # Not needed -> added to config/initializers/pagy.rb
  # include Pagy::Frontend

  COLOR_STATUSES = {
    alert: 'px-4 py-3 leading-normal font-bold text-red-500 border border-l-4 border-red-500 rounded-lg',
    notice: 'px-4 py-3 leading-normal font-bold text-yellow-500 border border-l-4 border-yellow-500 rounded-lg'
  }.freeze

  def tailwind_class(type)
    COLOR_STATUSES[type.to_sym] || 'px-4 py-3 leading-normal font-bold text-gray-800 border border-l-4 border-gray-800 rounded-lg'
  end
end
