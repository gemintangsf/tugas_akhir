class CreatePenerimaNonBeasiswas < ActiveRecord::Migration[6.1]
  def change
    create_table :penerima_non_beasiswas do |t|

      t.timestamps
    end
  end
end
