class Like < ApplicationRecord
  belongs_to :user  #, counter_cache: true
  belongs_to :post
  validates :user_id, uniqueness: { scope: :post_id }

  after_create_commit do
    update_likes
  end

  after_update_commit do
  end

  after_destroy_commit do
    update_likes
  end

  def update_likes
    broadcast_update_to( post, target: "#{post.id}_like", partial: 'posts/likes_brc', locals: { post: post })
    broadcast_update_to( 'posts', target: "#{post.id}_like", partial: 'posts/likes_brc', locals: { post: post })
    # post.broadcast_update(target: "#{post.id}_like", partial: 'posts/likes_brc', locals: { post: post})
    # Turbo::StreamsChannel.broadcast_replace_to post, current_user, target:  "#{post.id}_like", partial: "posts/likes", locals: { post: post, user: current_user }
  end
end
