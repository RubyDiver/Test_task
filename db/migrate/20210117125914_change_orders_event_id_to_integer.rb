class ChangeOrdersEventIdToInteger < ActiveRecord::Migration[5.2]
  def up
    change_column :orders, :event_id, :integer
  end

  def down
    change_column :orders, :event_id, :bigint
  end
end
