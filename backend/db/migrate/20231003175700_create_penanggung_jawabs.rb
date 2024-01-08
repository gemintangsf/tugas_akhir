class CreatePenanggungJawabs < ActiveRecord::Migration[6.1]
  def change
    create_table :penanggung_jawabs do |t|

      t.timestamps
    end
  end
end
