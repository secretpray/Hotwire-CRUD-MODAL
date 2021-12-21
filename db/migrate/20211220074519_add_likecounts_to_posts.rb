class AddLikecountsToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :likes_count, :integer, null: false, default: 0

    Post.reset_column_information
    Post.all.find_each do |post|
      Post.reset_counters(post.id, :likes) # rescue nil
    end

    # Post.pluck(:id).each do |p_id|
    #   Post.reset_counters p_id, :likes
    # end
  end
end
