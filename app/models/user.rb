class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy, inverse_of: :user
  has_one_attached :avatar

  validates :email, presence: true, uniqueness: {case_sensitive: false}
end
