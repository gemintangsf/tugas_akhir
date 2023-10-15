class CreateDonaturs < ActiveRecord::Migration[6.1]
  def change
    create_table :donaturs do |t|

      t.timestamps
    end
  end
end
