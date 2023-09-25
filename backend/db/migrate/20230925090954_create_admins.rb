class CreateAdmins < ActiveRecord::Migration[6.1]
  def change
    create_table :admins do |t|
      t.string :nama
      t.string :role
      t.string :username
      t.string :password_digest
      t.string :nomor_telepon
      t.references :rekening, null: false, foreign_key: true

      t.timestamps
    end
  end
end
