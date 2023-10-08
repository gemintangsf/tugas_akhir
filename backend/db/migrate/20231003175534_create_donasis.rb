class CreateDonasis < ActiveRecord::Migration[6.1]
  def change
    create_table :donasis do |t|

      t.timestamps
    end
  end
end
