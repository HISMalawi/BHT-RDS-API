class CreatePharmacyBatchItemReallocations < ActiveRecord::Migration[5.2]
  def change
    create_table :pharmacy_batch_item_reallocations do |t|
      t.string :reallocation_code
      t.integer :batch_item_id, limit: 8
      t.float :quantity
      t.integer :location_id
      t.datetime :date_created, options: -> { 'DEFAULT NOW()' }
      t.integer :creator, limit: 8
      t.boolean :voided, options: -> { 'DEFAULT 0' }
      t.integer :voided_by, limit: 8
      t.datetime :date_voided
      t.integer :changed_by, limit: 8
      t.datetime :date_changed, null: false, options: -> { 'DEFAULT NOW()' }
    end
  end
end
