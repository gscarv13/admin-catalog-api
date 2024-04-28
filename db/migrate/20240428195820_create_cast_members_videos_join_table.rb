class CreateCastMembersVideosJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :cast_members_videos, id: false do |t|
      t.string 'cast_member_id'
      t.string 'video_id'
    end
  end
end
