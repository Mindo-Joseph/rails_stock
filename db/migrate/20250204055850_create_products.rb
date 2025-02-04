class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :quantity, default: 0, null: false
      t.integer :low_stock_threshold, default: 10
      t.string :sku, null: false
      t.index :sku, unique: true

      t.timestamps
    end
  end
end
