class CreateCivitasAkademikas < ActiveRecord::Migration[6.1]
  def change
    create_table :civitas_akademikas do |t|
      t.string :nama
      t.string :nomor_induk

      t.timestamps
    end
  end
end
