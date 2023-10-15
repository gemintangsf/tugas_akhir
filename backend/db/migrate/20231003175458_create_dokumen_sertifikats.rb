class CreateDokumenSertifikats < ActiveRecord::Migration[6.1]
  def change
    create_table :dokumen_sertifikats do |t|

      t.timestamps
    end
  end
end
