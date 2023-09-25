class CreateDonaturs < ActiveRecord::Migration[6.1]
  def change
    create_table :donaturs do |t|
      t.string :nama
      t.string :nomor_telepon
      t.string :password_digest
      t.boolean :status
      t.references :rekening, null: false, foreign_key: true
      t.references :donasi, null: false, foreign_key: true

      t.timestamps
    end
  end
end
