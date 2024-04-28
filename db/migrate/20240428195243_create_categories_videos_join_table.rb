class CreateCategoriesVideosJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :categories_videos, id: false do |t|
      t.string 'category_id'
      t.string 'video_id'
    end
  end
end
