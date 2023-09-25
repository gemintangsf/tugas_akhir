class CreateDonasis < ActiveRecord::Migration[6.1]
  def change
    create_table :donasis do |t|
      t.integer :nominal_donasi
      t.string :struk_pembayaran
      t.string :nomor_referensi
      t.time :waktu_berakhir
      t.integer :status

      t.timestamps
    end
  end
end
