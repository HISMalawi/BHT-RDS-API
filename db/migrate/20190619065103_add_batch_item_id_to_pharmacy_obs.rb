class AddBatchItemIdToPharmacyObs < ActiveRecord::Migration[5.2]
  def change
    add_column :pharmacy_obs, :batch_item_id, :integer, limit: 8, null: true
  end
end
