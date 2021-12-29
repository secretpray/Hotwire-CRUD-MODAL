module UsersHelper

  def is_author?(object, user_id)
    user_id == object.user_id
  end
end
