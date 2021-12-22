class AddCommentCounterToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :comments_count, :integer, null: false, default: 0

    Post.reset_column_information
    Post.all.find_each do |post|
      post.update_attribute :comments_count, post.comments.length
    end
  end
end
