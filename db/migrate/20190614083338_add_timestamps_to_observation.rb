class AddTimestampsToObservation < ActiveRecord::Migration[5.2]
  def change
    add_column :obs, :created_at, :datetime, null: false, options: -> { 'DEFAULT NOW()' }
    add_column :obs, :updated_at, :datetime, null: false, options: -> { 'DEFAULT NOW()' }
  end
end
