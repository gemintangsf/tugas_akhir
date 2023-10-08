class CreateMahasiswas < ActiveRecord::Migration[6.1]
  def change
    create_table :mahasiswas do |t|

      t.timestamps
    end
  end
end
