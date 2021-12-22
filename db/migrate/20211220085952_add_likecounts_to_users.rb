class AddLikecountsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :likes_count, :integer, null: false, default: 0

    User.reset_column_information
    User.all.find_each do |user|
      User.reset_counters(user.id, :likes) # rescue nil
    end
  end
end
