class AddTimestampsToPatient < ActiveRecord::Migration[5.2]
  def change
    add_column :patient, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP()' }
    add_column :patient, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP()' }
  end
end
