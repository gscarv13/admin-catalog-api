class CreateCastMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :cast_members, id: :string do |t|
      t.string :name
      t.integer :role_type, default: 0

      t.timestamps
    end
  end
end
