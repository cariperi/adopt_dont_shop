class CreatePets < ActiveRecord::Migration[5.2]
  def change
    create_table :pets do |t|
      t.boolean :adoptable
      t.integer :age
      t.string :breed
      t.string :name
      t.string :pet_status, default: "Pending Approval", null: false
      t.references :shelter, null: false, foreign_key: true

      t.timestamps
    end
  end
end
