class OrdersCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    order.destroy unless order.closed?
  end
end
