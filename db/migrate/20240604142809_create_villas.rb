class CreateVillas < ActiveRecord::Migration[7.1]
  def change
    create_table :villas do |t|
      t.string :name
      t.text :description
      t.string :guest

      t.timestamps
    end
  end
end
