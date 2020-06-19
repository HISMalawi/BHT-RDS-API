class AddTimeStampsToPhamarcyTables < ActiveRecord::Migration[5.2]
  def change
  	change_column :pharmacies, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    change_column :pharmacies, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }

    change_column :pharmacy_batch_items, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    change_column :pharmacy_batch_items, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }

    change_column :pharmacy_batches, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    change_column :pharmacy_batches, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }

    change_column :pharmacy_batch_item_reallocations, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    change_column :pharmacy_batch_item_reallocations, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
