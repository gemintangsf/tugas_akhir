class CreateCivitasAkademikas < ActiveRecord::Migration[6.1]
  def change
    create_table :civitas_akademikas do |t|

      t.timestamps
    end
  end
end
