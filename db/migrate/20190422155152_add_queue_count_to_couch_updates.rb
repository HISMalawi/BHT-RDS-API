class AddQueueCountToCouchUpdates < ActiveRecord::Migration[5.2]
  def change
    add_column :couch_updates, :queue_count, :integer, default: 0
  end
end
