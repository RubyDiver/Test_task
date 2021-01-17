class ChangeTicketsOrderIdToInteger < ActiveRecord::Migration[5.2]
  def up
    change_column :tickets, :order_id, :integer
  end

  def down
    change_column :tickets, :order_id, :bigint
  end
end
