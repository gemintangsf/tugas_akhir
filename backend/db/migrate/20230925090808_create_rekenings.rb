class CreateRekenings < ActiveRecord::Migration[6.1]
  def change
    create_table :rekenings do |t|
      t.string :nama_bank
      t.string :nomor_rekening
      t.string :nama_pemilik_rekening

      t.timestamps
    end
  end
end
