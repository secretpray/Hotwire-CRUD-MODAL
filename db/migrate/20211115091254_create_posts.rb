class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false, unique: true, index: true
      t.text :content
      t.integer :status, null: false, default: 0
      t.string :category

      t.timestamps
    end
    # add_index :posts, :title
  end
end
