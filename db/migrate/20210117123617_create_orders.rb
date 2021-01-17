class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :tickets_amount
      t.integer :status
      t.references :event, null: false, foreign_key: true
      t.datetime :expires_at
      t.decimal :sum

      t.timestamps
    end
  end
end
