class CreateNonBeasiswas < ActiveRecord::Migration[6.1]
  def change
    create_table :non_beasiswas do |t|
      t.string :nama_penerima
      t.string :no_identitas_penerima
      t.string :no_telepon_penerima
      t.string :bukti_butuh_bantuan
      t.string :kategori

      t.timestamps
    end
  end
end
