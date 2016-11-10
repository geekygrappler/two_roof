class CreateLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :line_items do |t|
      t.string :item_name
      t.references :document, foreign_key: true
      t.text :notes
      t.integer :quantity
      t.integer :rate

      t.timestamps
    end
  end
end
