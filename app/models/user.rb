class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  has_many :posts, dependent: :destroy, inverse_of: :user
  has_many :comments, dependent: :destroy, inverse_of: :user
  has_many :likes, dependent: :destroy, inverse_of: :user

  kredis_unique_list :recent_searches, limit: 5 # recent_searches.elements.each { |el| recent_searches.remove(el) }
  attr_accessor :online_user_ids # kredis_unique_list :online_user_ids

  validates :email, presence: true, uniqueness: {case_sensitive: false}

  # AddRemoveFind online user service
  def self.online_user_ids
    @online_user_ids ||= Kredis.unique_list "online_user_ids"
  end

  def self.add_online_user(user_id)
    online_user_ids << user_id
  end

  def self.remove_online_user(user_id)
    online_user_ids.remove(user_id)
  end

  def self.online_users_reset
    Kredis.clear_all
  end

  def self.online_users_count
    online_user_ids.elements.count
  end

  def self.online_users
    User.where(id: online_user_ids.elements).pluck(:id) # for tets (1..5).to_a
  end

  def update_user_search_history(histories)
    broadcast_update_to :user_history, target: 'history', partial: 'users/search_histories', locals: { histories: histories }
  end
end
