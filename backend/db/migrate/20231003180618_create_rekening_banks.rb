class CreateRekeningBanks < ActiveRecord::Migration[6.1]
  def change
    create_table :rekening_banks do |t|

      t.timestamps
    end
  end
end
