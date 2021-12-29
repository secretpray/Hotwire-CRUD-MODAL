ActiveSupport.on_load :action_controller_base do
  include Pagy::Backend
end

ActiveSupport.on_load :action_view do
  include Pagy::UrlHelpers
end

# Pagy::DEFAULT[:page] = 1 # default page to start with
# Pagy::DEFAULT[:items] = 10 # items per page
# Pagy::DEFAULT[:cycle] = true # when on last page, click "Next" to go to first page

# require 'pagy/extras/items'
# Pagy::DEFAULT[:max_items] = 200 # max items possible per page

# require 'pagy/extras/overflow'
# Pagy::DEFAULT[:overflow] = :last_page # default (other options: :empty_page and :exception)
