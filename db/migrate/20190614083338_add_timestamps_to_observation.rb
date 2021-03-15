class AddTimestampsToObservation < ActiveRecord::Migration[5.2]
  def change
    add_column :obs, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP()' }
    add_column :obs, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP()' }
  end
end
