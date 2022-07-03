class CreateThings < ActiveRecord::Migration[7.0]
  def change
    create_table :things do |t|
      t.date :date
      t.string :title
      t.string :content

      t.timestamps
    end
  end
end
