class CreatePenanggungJawabNonBeasiswaHasPenerimaNonBeasiswas < ActiveRecord::Migration[6.1]
  def change
    create_table :penanggung_jawab_non_beasiswa_has_penerima_non_beasiswas do |t|

      t.timestamps
    end
  end
end
