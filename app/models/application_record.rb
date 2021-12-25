class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :recent, -> { order(created_at: :desc) }
  scope :recently_updated , -> { order(updated_at: :desc) }
  scope :created_today, -> { 
    where('created_at > ?', Date.current.beginning_of_day).
    where('created_at < ?', Date.current.end_of_day )
  }
end
