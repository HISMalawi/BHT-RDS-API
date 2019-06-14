class AddTimestampsToPatientIdentifier < ActiveRecord::Migration[5.2]
  def change
    add_column :patient_identifier, :created_at, :datetime, null: false, options: -> { 'DEFAULT NOW()' }
    add_column :patient_identifier, :updated_at, :datetime, null: false, options: -> { 'DEFAULT NOW()' }
  end
end
