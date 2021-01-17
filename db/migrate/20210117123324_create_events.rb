class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :start_at
      t.datetime :end_at
      t.integer :tickets_total
      t.integer :tickets_sold
      t.decimal :ticket_price

      t.timestamps
    end
  end
end
