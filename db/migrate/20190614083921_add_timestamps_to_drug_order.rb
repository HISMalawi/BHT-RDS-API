class AddTimestampsToDrugOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :drug_order, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :drug_order, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
