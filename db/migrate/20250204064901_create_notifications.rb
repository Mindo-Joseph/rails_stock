class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :title, null: false
      t.text :message
      t.integer :status, default: 0
      t.references :product, null: false, foreign_key: true
      t.datetime :read_at

      t.timestamps
    end
  end
end
