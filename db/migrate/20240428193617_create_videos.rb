class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos, id: :string do |t|
      t.string :title
      t.text :description
      t.integer :launch_year
      t.string :duration
      t.boolean :published
      t.integer :rating, default: 0

      t.timestamps
    end
  end
end
