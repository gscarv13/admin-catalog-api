class CreateGenresVideosJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :genres_videos, id: false do |t|
      t.string 'genre_id'
      t.string 'video_id'
    end
  end
end
