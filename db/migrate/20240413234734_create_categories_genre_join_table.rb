class CreateCategoriesGenreJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :categories_genres, id: false do |t|
      t.string 'genre_id'
      t.string 'category_id'
    end
  end
end
