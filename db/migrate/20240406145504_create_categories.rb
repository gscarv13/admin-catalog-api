class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories, id: :string do |t|
      t.string :name
      t.text :description
      t.boolean :is_active, default: true

      t.timestamps
    end

    add_index :categories, :id, unique: true
  end
end
