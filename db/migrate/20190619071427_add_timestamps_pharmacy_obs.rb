class AddTimestampsPharmacyObs < ActiveRecord::Migration[5.2]
  def change
    add_column :pharmacy_obs, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :pharmacy_obs, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
