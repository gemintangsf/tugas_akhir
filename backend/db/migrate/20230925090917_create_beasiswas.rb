class CreateBeasiswas < ActiveRecord::Migration[6.1]
  def change
    create_table :beasiswas do |t|
      t.integer :golongan_ukt
      t.string :kuitansi_pembayaran_ukt
      t.integer :gaji_orang_tua
      t.string :bukti_slip_gaji_orang_tua
      t.string :esai
      t.integer :jumlah_tanggungan_keluarga
      t.string :biaya_transportasi
      t.string :biaya_konsumsi
      t.string :biaya_internet
      t.string :biaya_kost
      t.integer :total_pengeluaran_keluarga
      t.integer :penilaian_esai
      t.integer :nominal_penyaluran
      t.json :bulan_penyaluran

      t.timestamps
    end
  end
end
