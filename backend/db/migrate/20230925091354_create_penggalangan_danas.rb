class CreatePenggalanganDanas < ActiveRecord::Migration[6.1]
  def change
    create_table :penggalangan_danas do |t|
      t.integer :total_pengajuan
      t.integer :total_nominal_terkumpul
      t.references :donasi, null: false, foreign_key: true
      t.references :pengaju_bantuan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
