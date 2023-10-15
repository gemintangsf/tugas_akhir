class CreatePenanggungJawabNonBeasiswas < ActiveRecord::Migration[6.1]
  def change
    create_table :penanggung_jawab_non_beasiswas do |t|

      t.timestamps
    end
  end
end
