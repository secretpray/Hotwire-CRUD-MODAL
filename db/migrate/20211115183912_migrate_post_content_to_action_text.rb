class MigratePostContentToActionText < ActiveRecord::Migration[6.1]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :posts, :content, :content_old
    Post.all.each do |post|
      post.update_attribute(:content, simple_format(post.content_old))
    end
    remove_column :posts, :content_old
  end
end
