class CreateGenres < ActiveRecord::Migration[7.1]
  def change
    create_table :genres, id: :string do |t|
      t.string :name
      t.boolean :is_active, default: true

      t.timestamps
    end

    add_index :genres, :id, unique: true
  end
end
