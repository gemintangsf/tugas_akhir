class CreatePengajuBantuans < ActiveRecord::Migration[6.1]
  def change
    create_table :pengaju_bantuans do |t|
      t.string :nama
      t.string :no_identitas_pengaju
      t.string :no_telepon
      t.string :waktu_galang_dana
      t.string :judul_galang_dana
      t.string :deskripsi
      t.string :dana_yang_dibutuhkan
      t.string :jenis
      t.integer :status_pengajuan
      t.integer :status_penyaluran
      t.references :beasiswa, null: false, foreign_key: true
      t.references :non_beasiswa, null: false, foreign_key: true
      t.references :rekening, null: false, foreign_key: true

      t.timestamps
    end
  end
end
