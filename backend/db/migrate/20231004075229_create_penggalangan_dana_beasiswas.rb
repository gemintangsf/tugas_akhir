class CreatePenggalanganDanaBeasiswas < ActiveRecord::Migration[6.1]
  def change
    create_table :penggalangan_dana_beasiswas do |t|

      t.timestamps
    end
  end
end
