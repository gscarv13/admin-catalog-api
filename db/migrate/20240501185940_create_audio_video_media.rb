class CreateAudioVideoMedia < ActiveRecord::Migration[7.1]
  def change
    create_table :audio_video_media, id: :string do |t|
      t.belongs_to :video
      t.string :name
      t.string :raw_location
      t.string :encoded_location
      t.integer :status

      t.timestamps
    end
  end
end
