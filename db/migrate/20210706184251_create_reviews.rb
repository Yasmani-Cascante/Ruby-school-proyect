class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.string :book_title
      t.string :body
      t.string :image_url
      t.string :book_author

      t.timestamps
    end
  end
end
