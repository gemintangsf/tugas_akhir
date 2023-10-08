class CreateRekapitulasiBeasiswas < ActiveRecord::Migration[6.1]
  def change
    create_table :rekapitulasi_beasiswas do |t|

      t.timestamps
    end
  end
end
