class CreatePetApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :pet_applications do |t|
      t.references :pet, foreign_key: true
      t.references :application, foreign_key: true

      t.string :pet_status, default: "Pending Approval", null: false

      t.timestamps
    end
  end
end
